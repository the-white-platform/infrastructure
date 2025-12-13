#!/bin/bash
set -e

# Configuration
PROJECT_ID="the-white-dev"
REGION="europe-north1"
DOMAIN="thewhite.cool"

echo "🔍 Fetching DNS configuration for $DOMAIN..."

# Check if domain mapping exists
if ! gcloud beta run domain-mappings describe --domain "$DOMAIN" --region "$REGION" --project "$PROJECT_ID" > /dev/null 2>&1; then
    echo "❌ Domain mapping for $DOMAIN not found."
    echo "   Ensure your latest Terraform deploy finished successfully."
    exit 1
fi

echo "✅ Domain mapping found!"
echo ""
echo "---------------------------------------------------------"
echo "📋 ENTER THESE RECORDS IN PORKBUN DNS:"
echo "---------------------------------------------------------"
echo ""

# Extract and display records
gcloud beta run domain-mappings describe --domain "$DOMAIN" --region "$REGION" --project "$PROJECT_ID" --format="json" | \
jq -r '.status.resourceRecords[] | "Type: \(.type)\nHost: \(.name // "@")\nValue: \(.rrdata)\n"'

echo "---------------------------------------------------------"
echo "ℹ️  Note: It may take up to 60 minutes for the certificate to provision after you add these records."
