#!/bin/bash

# Deployment script for The White Platform
# Usage: ./deploy.sh [environment] [options]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
ENVIRONMENT=""
AUTO_APPROVE=false
PLAN_ONLY=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        dev|staging|prod)
            ENVIRONMENT="$1"
            shift
            ;;
        --auto-approve)
            AUTO_APPROVE=true
            shift
            ;;
        --plan-only)
            PLAN_ONLY=true
            shift
            ;;
        -h|--help)
            echo "Usage: ./deploy.sh [environment] [options]"
            echo ""
            echo "Environments:"
            echo "  dev       Deploy to development"
            echo "  staging   Deploy to staging"
            echo "  prod      Deploy to production"
            echo ""
            echo "Options:"
            echo "  --auto-approve  Skip interactive approval"
            echo "  --plan-only     Only run terraform plan"
            echo "  -h, --help      Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown argument: $1${NC}"
            exit 1
            ;;
    esac
done

# Validate environment
if [ -z "$ENVIRONMENT" ]; then
    echo -e "${RED}❌ Environment is required${NC}"
    echo "Usage: ./deploy.sh [dev|staging|prod]"
    exit 1
fi

echo -e "${BLUE}🚀 Deploying to ${ENVIRONMENT} environment${NC}"
echo ""

# Navigate to environment directory
ENV_DIR="../terraform/environments/${ENVIRONMENT}"

if [ ! -d "$ENV_DIR" ]; then
    echo -e "${RED}❌ Environment directory not found: ${ENV_DIR}${NC}"
    exit 1
fi

cd "$ENV_DIR"

# Check if terraform.tfvars exists
if [ ! -f "terraform.tfvars" ]; then
    echo -e "${RED}❌ terraform.tfvars not found${NC}"
    echo "Please run setup-env.sh first"
    exit 1
fi

# Initialize Terraform
echo -e "${GREEN}📦 Initializing Terraform...${NC}"
terraform init -upgrade

# Validate configuration
echo -e "${GREEN}✅ Validating configuration...${NC}"
terraform validate

# Format check
echo -e "${GREEN}🎨 Checking formatting...${NC}"
terraform fmt -check || {
    echo -e "${YELLOW}⚠️  Formatting issues found. Auto-fixing...${NC}"
    terraform fmt -recursive
}

# Plan
echo -e "${GREEN}📋 Planning deployment...${NC}"
if [ "$AUTO_APPROVE" = true ]; then
    terraform plan -out=tfplan
else
    terraform plan -out=tfplan -detailed-exitcode || {
        EXIT_CODE=$?
        if [ $EXIT_CODE -eq 2 ]; then
            echo -e "${YELLOW}⚠️  Changes detected${NC}"
        elif [ $EXIT_CODE -ne 0 ]; then
            echo -e "${RED}❌ Planning failed${NC}"
            exit $EXIT_CODE
        fi
    }
fi

# Exit if plan-only
if [ "$PLAN_ONLY" = true ]; then
    echo -e "${GREEN}✅ Plan complete (plan-only mode)${NC}"
    exit 0
fi

# Confirm deployment
if [ "$AUTO_APPROVE" = false ]; then
    echo ""
    echo -e "${YELLOW}⚠️  You are about to deploy to ${ENVIRONMENT}${NC}"
    read -p "Continue? (yes/no): " CONFIRM
    
    if [ "$CONFIRM" != "yes" ]; then
        echo -e "${RED}❌ Deployment cancelled${NC}"
        rm -f tfplan
        exit 0
    fi
fi

# Apply
echo -e "${GREEN}🚀 Applying changes...${NC}"
if [ "$AUTO_APPROVE" = true ]; then
    terraform apply -auto-approve tfplan
else
    terraform apply tfplan
fi

# Clean up plan file
rm -f tfplan

# Show outputs
echo ""
echo -e "${GREEN}✅ Deployment complete!${NC}"
echo ""
echo -e "${BLUE}📊 Outputs:${NC}"
terraform output

# Get service URL
SERVICE_URL=$(terraform output -raw service_url 2>/dev/null || echo "N/A")
echo ""
echo -e "${GREEN}🌐 Service URL: ${SERVICE_URL}${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Verify the deployment: curl ${SERVICE_URL}"
echo "2. Check logs: gcloud run services logs read fashion-web-${ENVIRONMENT}"
echo "3. Monitor metrics in GCP Console"
