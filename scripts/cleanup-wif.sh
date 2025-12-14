#!/bin/bash

# Cleanup script for Workload Identity Federation
# Use this if you need to start fresh

set -e

PROJECT_ID="${1:-the-white-dev-481217}"
WORKLOAD_IDENTITY_POOL="github-pool"
WORKLOAD_IDENTITY_PROVIDER="github-provider"

echo "🧹 Cleaning up Workload Identity Federation for ${PROJECT_ID}..."
echo ""

# Delete provider if it exists
if gcloud iam workload-identity-pools providers describe "${WORKLOAD_IDENTITY_PROVIDER}" \
    --project="${PROJECT_ID}" \
    --location="global" \
    --workload-identity-pool="${WORKLOAD_IDENTITY_POOL}" &>/dev/null; then
    echo "Deleting provider..."
    gcloud iam workload-identity-pools providers delete "${WORKLOAD_IDENTITY_PROVIDER}" \
        --project="${PROJECT_ID}" \
        --location="global" \
        --workload-identity-pool="${WORKLOAD_IDENTITY_POOL}" \
        --quiet
    echo "✅ Provider deleted"
else
    echo "ℹ️  Provider doesn't exist"
fi

# Delete pool if it exists
if gcloud iam workload-identity-pools describe "${WORKLOAD_IDENTITY_POOL}" \
    --project="${PROJECT_ID}" \
    --location="global" &>/dev/null; then
    echo "Deleting pool..."
    gcloud iam workload-identity-pools delete "${WORKLOAD_IDENTITY_POOL}" \
        --project="${PROJECT_ID}" \
        --location="global" \
        --quiet
    echo "✅ Pool deleted"
else
    echo "ℹ️  Pool doesn't exist"
fi

echo ""
echo "✅ Cleanup complete! You can now run setup-github-actions.sh again"

