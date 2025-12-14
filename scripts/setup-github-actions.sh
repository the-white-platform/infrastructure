#!/bin/bash

# Setup script for GitHub Actions Workload Identity Federation
# This allows GitHub Actions to authenticate to GCP without storing service account keys

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🔐 Setting up GitHub Actions Workload Identity Federation${NC}"
echo ""

# Configuration
REPO="the-white-platform/infrastructure"
WORKLOAD_IDENTITY_POOL="github-pool"
WORKLOAD_IDENTITY_PROVIDER="github-provider"

# Function to setup WIF for an environment
setup_wif() {
    local ENV=$1
    local PROJECT_ID=$2
    
    echo -e "${YELLOW}📋 Setting up ${ENV} environment (${PROJECT_ID})${NC}"
    
    # Set the project
    gcloud config set project "${PROJECT_ID}" --quiet
    
    # Get project number
    PROJECT_NUMBER=$(gcloud projects describe "${PROJECT_ID}" --format="value(projectNumber)")
    
    # Check if pool already exists
    if gcloud iam workload-identity-pools describe "${WORKLOAD_IDENTITY_POOL}" \
        --project="${PROJECT_ID}" \
        --location="global" &>/dev/null; then
        echo -e "${YELLOW}  ⚠️  Workload Identity Pool already exists, skipping creation${NC}"
    else
        echo -e "${GREEN}  Creating Workload Identity Pool...${NC}"
        gcloud iam workload-identity-pools create "${WORKLOAD_IDENTITY_POOL}" \
            --project="${PROJECT_ID}" \
            --location="global" \
            --display-name="GitHub Actions Pool" \
            --quiet
    fi
    
    # Check if provider already exists
    if gcloud iam workload-identity-pools providers describe "${WORKLOAD_IDENTITY_PROVIDER}" \
        --project="${PROJECT_ID}" \
        --location="global" \
        --workload-identity-pool="${WORKLOAD_IDENTITY_POOL}" &>/dev/null; then
        echo -e "${YELLOW}  ⚠️  Workload Identity Provider already exists, skipping creation${NC}"
    else
        echo -e "${GREEN}  Creating Workload Identity Provider...${NC}"
        gcloud iam workload-identity-pools providers create-oidc "${WORKLOAD_IDENTITY_PROVIDER}" \
            --project="${PROJECT_ID}" \
            --location="global" \
            --workload-identity-pool="${WORKLOAD_IDENTITY_POOL}" \
            --display-name="GitHub Actions Provider" \
            --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
            --issuer-uri="https://token.actions.githubusercontent.com" \
            --quiet
    fi
    
    # Get the provider resource name
    PROVIDER_NAME=$(gcloud iam workload-identity-pools providers describe "${WORKLOAD_IDENTITY_PROVIDER}" \
        --project="${PROJECT_ID}" \
        --location="global" \
        --workload-identity-pool="${WORKLOAD_IDENTITY_POOL}" \
        --format="value(name)")
    
    echo -e "${GREEN}  Provider name: ${PROVIDER_NAME}${NC}"
    
    # Service account
    SERVICE_ACCOUNT="terraform-sa@${PROJECT_ID}.iam.gserviceaccount.com"
    
    # Check if service account exists
    if ! gcloud iam service-accounts describe "${SERVICE_ACCOUNT}" --project="${PROJECT_ID}" &>/dev/null; then
        echo -e "${RED}  ❌ Service account ${SERVICE_ACCOUNT} does not exist!${NC}"
        echo -e "${YELLOW}  Please run terraform/bootstrap first to create the service account${NC}"
        return 1
    fi
    
    # Allow GitHub Actions to impersonate the service account
    echo -e "${GREEN}  Granting Workload Identity User role...${NC}"
    MEMBER="principalSet://iam.googleapis.com/projects/${PROJECT_NUMBER}/locations/global/workloadIdentityPools/${WORKLOAD_IDENTITY_POOL}/attribute.repository/${REPO}"
    
    gcloud iam service-accounts add-iam-policy-binding "${SERVICE_ACCOUNT}" \
        --project="${PROJECT_ID}" \
        --role="roles/iam.workloadIdentityUser" \
        --member="${MEMBER}" \
        --quiet || echo -e "${YELLOW}  ⚠️  Policy binding may already exist${NC}"
    
    echo ""
    echo -e "${GREEN}✅ ${ENV} environment setup complete!${NC}"
    echo ""
    echo -e "${YELLOW}📝 Add these secrets to GitHub (${REPO}):${NC}"
    echo -e "   ${GREEN}WIF_PROVIDER_${ENV^^}${NC} = ${PROVIDER_NAME}"
    echo -e "   ${GREEN}WIF_SERVICE_ACCOUNT_${ENV^^}${NC} = ${SERVICE_ACCOUNT}"
    echo ""
}

# Main
echo "This script will set up Workload Identity Federation for both dev and prod."
echo "Make sure you're authenticated: gcloud auth login"
echo ""

# Setup Dev
setup_wif "DEV" "the-white-dev-481217"

# Setup Prod
setup_wif "PROD" "the-white-prod-481217"

echo -e "${GREEN}🎉 Setup complete!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Add the secrets shown above to your GitHub repository"
echo "2. Commit and push the workflow files"
echo "3. Test by pushing to main (dev) or creating a tag (prod)"

