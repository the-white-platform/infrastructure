# IAM permissions for cross-project Artifact Registry access
# This allows the prod GitHub Actions service account to copy images from dev to prod Artifact Registry

# Data source to get the prod service account (created in prod environment)
# Note: Prod terraform must be applied first before this will work
data "google_service_account" "prod_github_actions" {
  account_id = "github-actions-deployer"
  project    = "the-white-prod-481217"
}

# Grant prod GitHub Actions service account READ access to dev Artifact Registry
# This is needed to copy images from dev registry to prod registry
# IMPORTANT: Apply prod terraform first, then dev, so the prod SA exists
resource "google_artifact_registry_repository_iam_member" "prod_read_dev_images" {
  project    = var.project_id
  location   = var.region
  repository = "app-images"
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${data.google_service_account.prod_github_actions.email}"
  
  # This depends on the prod service account existing
  depends_on = [data.google_service_account.prod_github_actions]
}



