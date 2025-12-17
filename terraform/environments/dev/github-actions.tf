# GitHub Actions service account and WIF configuration for fashion-web
# This allows GitHub Actions to deploy fashion-web using Workload Identity Federation

# Data source to get project info (needed for project number)
data "google_project" "project" {
  project_id = var.project_id
}

# Workload Identity Pool for GitHub Actions
resource "google_iam_workload_identity_pool" "github_actions_pool" {
  project                   = var.project_id
  workload_identity_pool_id = "github-pool"
  display_name              = "GitHub Actions Pool"
  description               = "Pool for GitHub Actions to authenticate to GCP"
  disabled                  = false
}

# Workload Identity Provider for GitHub Actions
resource "google_iam_workload_identity_pool_provider" "github_actions_provider" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Actions Provider"
  description                        = "OIDC provider for GitHub Actions"
  disabled                           = false

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  attribute_condition = "assertion.repository_owner == 'the-white-platform'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  lifecycle {
    create_before_destroy = true
    # Ignore project field changes - WIF resources use project numbers in IDs
    # but Terraform config uses project IDs, causing false replacement plans
    ignore_changes = [project]
  }
}

locals {
  wif_pool_name     = google_iam_workload_identity_pool.github_actions_pool.name
  wif_provider_name = google_iam_workload_identity_pool_provider.github_actions_provider.name
}

# Service account for GitHub Actions to deploy fashion-web
resource "google_service_account" "github_actions_deployer" {
  account_id   = "github-actions-deployer"
  display_name = "GitHub Actions Deployer (fashion-web)"
  description  = "Service account for GitHub Actions to build and deploy fashion-web"
  project      = var.project_id
}

# IAM roles for GitHub Actions service account
# This service account is used by GitHub Actions via WIF to run Terraform
# It needs broad permissions to manage infrastructure

# Allow pushing Docker images to Artifact Registry
resource "google_project_iam_member" "github_actions_artifact_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions_deployer.email}"
}

# Allow deploying to Cloud Run
resource "google_project_iam_member" "github_actions_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.github_actions_deployer.email}"
}

# Allow using service accounts (needed for Cloud Run deployment)
resource "google_project_iam_member" "github_actions_service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.github_actions_deployer.email}"
}

# Terraform permissions - needed to manage infrastructure
# Allow managing project services (enable/disable APIs)
resource "google_project_iam_member" "github_actions_service_usage_admin" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  member  = "serviceAccount:${google_service_account.github_actions_deployer.email}"
}

# Allow managing Secret Manager (including IAM policies)
resource "google_project_iam_member" "github_actions_secretmanager_admin" {
  project = var.project_id
  role    = "roles/secretmanager.admin"
  member  = "serviceAccount:${google_service_account.github_actions_deployer.email}"
}

# Allow managing monitoring resources (alert policies, etc.)
resource "google_project_iam_member" "github_actions_monitoring_admin" {
  project = var.project_id
  role    = "roles/monitoring.admin"
  member  = "serviceAccount:${google_service_account.github_actions_deployer.email}"
}

# Allow managing project IAM policies
resource "google_project_iam_member" "github_actions_project_iam_admin" {
  project = var.project_id
  role    = "roles/resourcemanager.projectIamAdmin"
  member  = "serviceAccount:${google_service_account.github_actions_deployer.email}"
}

# Allow managing storage (for Terraform state)
resource "google_project_iam_member" "github_actions_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.github_actions_deployer.email}"
}

# Allow managing Workload Identity Pools (needed for WIF resources)
resource "google_project_iam_member" "github_actions_workload_identity_pool_admin" {
  project = var.project_id
  role    = "roles/iam.workloadIdentityPoolAdmin"
  member  = "serviceAccount:${google_service_account.github_actions_deployer.email}"
}

# Allow managing service account IAM policies (needed for WIF bindings)
resource "google_project_iam_member" "github_actions_service_account_admin" {
  project = var.project_id
  role    = "roles/iam.serviceAccountAdmin"
  member  = "serviceAccount:${google_service_account.github_actions_deployer.email}"
}

# Allow getting access tokens (needed for GCS bucket access for Terraform state)
# Grant at project level
resource "google_project_iam_member" "github_actions_service_account_token_creator" {
  project = var.project_id
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:${google_service_account.github_actions_deployer.email}"
}

# Grant service account permission to get access tokens for itself
# This is needed for the service account to access GCS buckets
resource "google_service_account_iam_member" "github_actions_self_token_creator" {
  service_account_id = google_service_account.github_actions_deployer.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${google_service_account.github_actions_deployer.email}"
}

# Allow GitHub Actions (via WIF) to impersonate this service account
# This binds the WIF principal to the service account
resource "google_service_account_iam_member" "github_actions_wif_binding" {
  service_account_id = google_service_account.github_actions_deployer.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${local.wif_pool_name}/attribute.repository_owner/the-white-platform"
}

# Note: WIF pool and provider are now managed by Terraform
# This ensures the attribute mapping and condition are correctly set

