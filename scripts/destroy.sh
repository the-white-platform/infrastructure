#!/bin/bash

# Destroy script for The White Platform infrastructure
# Usage: ./destroy.sh prod

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get environment
ENVIRONMENT="$1"

# Validate environment
if [ "$ENVIRONMENT" != "prod" ]; then
    echo -e "${RED}❌ Only prod environment exists${NC}"
    echo "Usage: ./destroy.sh prod"
    exit 1
fi

echo -e "${RED}⚠️  WARNING: You are about to DESTROY the ${ENVIRONMENT} environment${NC}"
echo -e "${RED}This action cannot be undone!${NC}"
echo ""

echo -e "${RED}🚨 PRODUCTION ENVIRONMENT DETECTED 🚨${NC}"
echo -e "${RED}This will destroy ALL production resources!${NC}"
echo ""
read -p "Type 'destroy-production' to confirm: " CONFIRM

if [ "$CONFIRM" != "destroy-production" ]; then
    echo -e "${GREEN}✅ Destruction cancelled${NC}"
    exit 0
fi

# Navigate to environment directory
ENV_DIR="../terraform/environments/${ENVIRONMENT}"

if [ ! -d "$ENV_DIR" ]; then
    echo -e "${RED}❌ Environment directory not found: ${ENV_DIR}${NC}"
    exit 1
fi

cd "$ENV_DIR"

# Initialize Terraform
echo -e "${YELLOW}📦 Initializing Terraform...${NC}"
terraform init

# Plan destroy
echo -e "${YELLOW}📋 Planning destruction...${NC}"
terraform plan -destroy

# Final confirmation
echo ""
echo -e "${RED}⚠️  Last chance to cancel!${NC}"
read -p "Proceed with destruction? (yes/no): " FINAL_CONFIRM

if [ "$FINAL_CONFIRM" != "yes" ]; then
    echo -e "${GREEN}✅ Destruction cancelled${NC}"
    exit 0
fi

# Destroy
echo -e "${RED}💥 Destroying infrastructure...${NC}"
terraform destroy -auto-approve

echo ""
echo -e "${GREEN}✅ Infrastructure destroyed${NC}"
echo ""
echo -e "${YELLOW}Note: The following resources may need manual cleanup:${NC}"
echo "- GCS buckets (if not empty)"
echo "- Secret Manager secrets"
echo "- Container images in Artifact Registry"
