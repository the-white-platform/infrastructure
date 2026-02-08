# Infrastructure CI/CD Workflows

This directory contains GitHub Actions workflows for automating Terraform deployments.

## Workflows

### `terraform-prod.yml`
- **Trigger**: Tag creation (e.g., `v1.0.0`)
- **Action**: Runs `terraform apply` for prod environment
- **When**: After creating a version tag

## Setup

### 1. Enable Workload Identity Federation

You need to set up Workload Identity Federation to allow GitHub Actions to authenticate to GCP without storing service account keys.

```bash
# Set variables
PROJECT_ID="the-white-prod-481217"
SERVICE_ACCOUNT="terraform-sa@${PROJECT_ID}.iam.gserviceaccount.com"
WORKLOAD_IDENTITY_POOL="github-pool"
WORKLOAD_IDENTITY_PROVIDER="github-provider"
REPO="the-white-platform/infrastructure"

# Create Workload Identity Pool
gcloud iam workload-identity-pools create ${WORKLOAD_IDENTITY_POOL} \
  --project=${PROJECT_ID} \
  --location="global" \
  --display-name="GitHub Actions Pool"

# Create Workload Identity Provider
gcloud iam workload-identity-pools providers create-oidc ${WORKLOAD_IDENTITY_PROVIDER} \
  --project=${PROJECT_ID} \
  --location="global" \
  --workload-identity-pool=${WORKLOAD_IDENTITY_POOL} \
  --display-name="GitHub Actions Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" \
  --issuer-uri="https://token.actions.githubusercontent.com"

# Get the provider resource name
PROVIDER_NAME=$(gcloud iam workload-identity-pools providers describe ${WORKLOAD_IDENTITY_PROVIDER} \
  --project=${PROJECT_ID} \
  --location="global" \
  --workload-identity-pool=${WORKLOAD_IDENTITY_POOL} \
  --format="value(name)")

# Allow GitHub Actions to impersonate the service account
gcloud iam service-accounts add-iam-policy-binding ${SERVICE_ACCOUNT} \
  --project=${PROJECT_ID} \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/$(gcloud projects describe ${PROJECT_ID} --format='value(projectNumber)')/locations/global/workloadIdentityPools/${WORKLOAD_IDENTITY_POOL}/attribute.repository/${REPO}"
```

### 2. Add GitHub Secrets

Add these secrets to your GitHub repository (`the-white-platform/infrastructure`):

- `WIF_PROVIDER_PROD`: The full provider resource name (e.g., `projects/123456789/locations/global/workloadIdentityPools/github-pool/providers/github-provider`)
- `WIF_SERVICE_ACCOUNT_PROD`: The service account email (e.g., `terraform-sa@the-white-prod-481217.iam.gserviceaccount.com`)

### 3. Verify Service Account Permissions

Ensure the Terraform service account has the necessary permissions:

```bash
gcloud projects get-iam-policy ${PROJECT_ID} \
  --flatten="bindings[].members" \
  --filter="bindings.members:serviceAccount:terraform-sa@${PROJECT_ID}.iam.gserviceaccount.com"
```

The service account should have:
- `roles/editor` (or more specific roles)
- `roles/storage.legacyBucketOwner` (for state bucket)
- `roles/iam.serviceAccountUser`

## Deploy to Prod

1. Make changes to Terraform files
2. Commit and push to `main` branch
3. Create a version tag: `git tag v1.0.0 && git push origin v1.0.0`
4. Workflow automatically runs `terraform apply` for prod
