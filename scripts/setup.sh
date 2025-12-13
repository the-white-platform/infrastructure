#!/bin/bash

# Initial setup script for The White Platform Infrastructure
# This script sets up the GCS bucket for Terraform state and enables required APIs

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 The White Platform - Infrastructure Setup${NC}"
echo ""

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}❌ gcloud CLI is not installed. Please install it first.${NC}"
    echo "Visit: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Check if user is authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" &> /dev/null; then
    echo -e "${YELLOW}⚠️  Not authenticated. Running gcloud auth login...${NC}"
    gcloud auth login
fi

# Get project ID
echo -e "${YELLOW}📋 Please enter your GCP Project ID:${NC}"
read -p "Project ID: " PROJECT_ID

if [ -z "$PROJECT_ID" ]; then
    echo -e "${RED}❌ Project ID cannot be empty${NC}"
    exit 1
fi

# Set the project
echo -e "${GREEN}Setting project to: $PROJECT_ID${NC}"
gcloud config set project "$PROJECT_ID"

# Enable required APIs
echo -e "${GREEN}🔧 Enabling required GCP APIs...${NC}"
gcloud services enable \
    cloudresourcemanager.googleapis.com \
    serviceusage.googleapis.com \
    run.googleapis.com \
    cloudbuild.googleapis.com \
    secretmanager.googleapis.com \
    containerregistry.googleapis.com \
    compute.googleapis.com \
    vpcaccess.googleapis.com \
    monitoring.googleapis.com \
    logging.googleapis.com \
    storage-api.googleapis.com

echo -e "${GREEN}✅ APIs enabled successfully${NC}"

# Create GCS buckets for Terraform state
echo -e "${GREEN}📦 Creating GCS buckets for Terraform state...${NC}"

REGION="us-central1"

# Create buckets for each environment
for ENV in dev staging prod; do
    BUCKET_NAME="the-white-platform-terraform-state-${ENV}"
    
    if gsutil ls -b "gs://${BUCKET_NAME}" &> /dev/null; then
        echo -e "${YELLOW}⚠️  Bucket ${BUCKET_NAME} already exists, skipping...${NC}"
    else
        echo -e "${GREEN}Creating bucket: ${BUCKET_NAME}${NC}"
        gsutil mb -p "$PROJECT_ID" -c STANDARD -l "$REGION" "gs://${BUCKET_NAME}"
        
        # Enable versioning
        gsutil versioning set on "gs://${BUCKET_NAME}"
        
        echo -e "${GREEN}✅ Bucket ${BUCKET_NAME} created${NC}"
    fi
done

# Create service account for Terraform
echo -e "${GREEN}👤 Creating Terraform service account...${NC}"

SA_NAME="terraform-sa"
SA_EMAIL="${SA_NAME}@${PROJECT_ID}.iam.gserviceaccount.com"

if gcloud iam service-accounts describe "$SA_EMAIL" &> /dev/null; then
    echo -e "${YELLOW}⚠️  Service account ${SA_EMAIL} already exists, skipping...${NC}"
else
    gcloud iam service-accounts create "$SA_NAME" \
        --display-name="Terraform Service Account" \
        --description="Service account for managing infrastructure with Terraform"
    
    echo -e "${GREEN}✅ Service account created${NC}"
fi

# Grant necessary roles to the service account
echo -e "${GREEN}🔐 Granting roles to service account...${NC}"

ROLES=(
    "roles/editor"
    "roles/iam.serviceAccountUser"
    "roles/run.admin"
    "roles/storage.admin"
    "roles/secretmanager.admin"
)

for ROLE in "${ROLES[@]}"; do
    gcloud projects add-iam-policy-binding "$PROJECT_ID" \
        --member="serviceAccount:${SA_EMAIL}" \
        --role="$ROLE" \
        --quiet
done

echo -e "${GREEN}✅ Roles granted successfully${NC}"

# Create secrets in Secret Manager
echo -e "${GREEN}🔒 Setting up Secret Manager...${NC}"

echo -e "${YELLOW}Would you like to create secrets now? (y/n)${NC}"
read -p "Create secrets: " CREATE_SECRETS

if [ "$CREATE_SECRETS" = "y" ] || [ "$CREATE_SECRETS" = "Y" ]; then
    for ENV in dev staging prod; do
        echo -e "${GREEN}Creating secrets for ${ENV} environment...${NC}"
        
        # DATABASE_URI
        SECRET_NAME="DATABASE_URI"
        if [ "$ENV" != "prod" ]; then
            SECRET_NAME="${SECRET_NAME}_${ENV^^}"
        fi
        
        if gcloud secrets describe "$SECRET_NAME" &> /dev/null; then
            echo -e "${YELLOW}⚠️  Secret ${SECRET_NAME} already exists, skipping...${NC}"
        else
            echo -e "${YELLOW}Enter ${SECRET_NAME} (PostgreSQL connection string):${NC}"
            read -s DB_URI
            echo -n "$DB_URI" | gcloud secrets create "$SECRET_NAME" \
                --data-file=- \
                --replication-policy="automatic"
            echo -e "${GREEN}✅ Secret ${SECRET_NAME} created${NC}"
        fi
        
        # PAYLOAD_SECRET
        SECRET_NAME="PAYLOAD_SECRET"
        if [ "$ENV" != "prod" ]; then
            SECRET_NAME="${SECRET_NAME}_${ENV^^}"
        fi
        
        if gcloud secrets describe "$SECRET_NAME" &> /dev/null; then
            echo -e "${YELLOW}⚠️  Secret ${SECRET_NAME} already exists, skipping...${NC}"
        else
            echo -e "${YELLOW}Enter ${SECRET_NAME} (or press enter to generate):${NC}"
            read -s PAYLOAD_SECRET
            if [ -z "$PAYLOAD_SECRET" ]; then
                PAYLOAD_SECRET=$(openssl rand -hex 32)
                echo -e "${GREEN}Generated: ${PAYLOAD_SECRET}${NC}"
            fi
            echo -n "$PAYLOAD_SECRET" | gcloud secrets create "$SECRET_NAME" \
                --data-file=- \
                --replication-policy="automatic"
            echo -e "${GREEN}✅ Secret ${SECRET_NAME} created${NC}"
        fi
        
        # NEXT_PUBLIC_SERVER_URL
        SECRET_NAME="NEXT_PUBLIC_SERVER_URL"
        if [ "$ENV" != "prod" ]; then
            SECRET_NAME="${SECRET_NAME}_${ENV^^}"
        fi
        
        if gcloud secrets describe "$SECRET_NAME" &> /dev/null; then
            echo -e "${YELLOW}⚠️  Secret ${SECRET_NAME} already exists, skipping...${NC}"
        else
            echo -e "${YELLOW}Enter ${SECRET_NAME} (e.g., https://thewhite.cool):${NC}"
            read SERVER_URL
            echo -n "$SERVER_URL" | gcloud secrets create "$SECRET_NAME" \
                --data-file=- \
                --replication-policy="automatic"
            echo -e "${GREEN}✅ Secret ${SECRET_NAME} created${NC}"
        fi
    done
fi

echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Navigate to an environment directory (e.g., cd terraform/environments/dev)"
echo "2. Run the setup script: bash setup-env.sh"
echo "3. Edit terraform.tfvars with your project ID and configuration"
echo "4. Initialize Terraform: terraform init"
echo "5. Plan your deployment: terraform plan"
echo "6. Apply the configuration: terraform apply"
echo ""
echo -e "${GREEN}📚 Documentation: See infrastructure/README.md for more details${NC}"
