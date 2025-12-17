# IAM permissions for cross-project Artifact Registry access
# This allows the prod GitHub Actions service account to copy images from dev to prod Artifact Registry

# Grant prod GitHub Actions service account READ access to dev Artifact Registry
# This is needed to copy images from dev registry to prod registry
# Note: We construct the email directly instead of using a data source to avoid
# requiring cross-project service account read permissions
resource "google_artifact_registry_repository_iam_member" "prod_read_dev_images" {
  project    = var.project_id
  location   = var.region
  repository = "app-images"
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:github-actions-deployer@the-white-prod-481217.iam.gserviceaccount.com"
}



