#!/bin/bash

# Grant Terraform permissions to GitHub Actions service accounts
# This must be run manually before Terraform can apply the IAM changes
# Usage: ./grant-terraform-permissions.sh [dev|prod]

set -e

ENVIRONMENT="$1"

if [ -z "$ENVIRONMENT" ]; then
    echo "❌ Environment is required"
    echo "Usage: ./grant-terraform-permissions.sh [dev|prod]"
    exit 1
fi

if [ "$ENVIRONMENT" != "dev" ] && [ "$ENVIRONMENT" != "prod" ]; then
    echo "❌ Invalid environment: $ENVIRONMENT"
    echo "Valid environments: dev, prod"
    exit 1
fi

# Set project and service account based on environment
if [ "$ENVIRONMENT" = "dev" ]; then
    PROJECT_ID="the-white-dev-481217"
    SA_EMAIL="github-actions-deployer@${PROJECT_ID}.iam.gserviceaccount.com"
else
    PROJECT_ID="the-white-prod-481217"
    SA_EMAIL="github-actions-deployer@${PROJECT_ID}.iam.gserviceaccount.com"
fi

echo "🔐 Granting Terraform permissions to ${SA_EMAIL} in ${PROJECT_ID}..."

# Grant all required roles
ROLES=(
    "roles/serviceusage.serviceUsageAdmin"
    "roles/secretmanager.admin"
    "roles/monitoring.admin"
    "roles/resourcemanager.projectIamAdmin"
    "roles/storage.admin"
    "roles/iam.workloadIdentityPoolAdmin"
)

for ROLE in "${ROLES[@]}"; do
    echo "  Granting ${ROLE}..."
    gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
        --member="serviceAccount:${SA_EMAIL}" \
        --role="${ROLE}" \
        --condition=None \
        --quiet || echo "  ⚠️  Failed to grant ${ROLE} (may already be granted)"
done

echo "✅ Permissions granted!"
echo ""
echo "Next steps:"
echo "1. Run Terraform plan/apply - it should now have the necessary permissions"
echo "2. Terraform will manage these permissions going forward"
