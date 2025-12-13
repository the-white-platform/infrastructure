terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# 1. Enable Required APIs
# We use a set of strings to enable multiple APIs
resource "google_project_service" "enabled_apis" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "secretmanager.googleapis.com",
    "containerregistry.googleapis.com",
    "artifactregistry.googleapis.com", # Added for modern container storage
    "compute.googleapis.com",
    "vpcaccess.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "storage-api.googleapis.com",
    "iam.googleapis.com",
    "aiplatform.googleapis.com", # Vertex AI
    "retail.googleapis.com"      # Retail API
  ])

  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}

# 2. Reference existing Terraform State Bucket (created manually or by bootstrap)
# Note: We use data source instead of resource to avoid recreating existing buckets
data "google_storage_bucket" "terraform_state" {
  name = var.state_bucket_name
}

# 3. Create Terraform Service Account
resource "google_service_account" "terraform_sa" {
  account_id   = "terraform-sa"
  display_name = "Terraform Service Account"
  description  = "Service Account used by Cloud Build and Terraform to manage infrastructure"
  project      = var.project_id
}

# 4. Grant IAM Roles to the Service Account
resource "google_project_iam_member" "sa_roles" {
  for_each = toset([
    "roles/editor",                  # Broad access for creating resources
    "roles/run.admin",               # Cloud Run management
    "roles/storage.admin",           # Storage management (for state & assets)
    "roles/secretmanager.admin",     # Secret management
    "roles/iam.serviceAccountUser",  # Ability to act as other SAs
    "roles/artifactregistry.admin",  # Manage container images
    "roles/cloudbuild.builds.editor" # Manage builds
  ])

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.terraform_sa.email}"
}

# 5. Grant Terraform SA access to the state bucket
resource "google_storage_bucket_iam_member" "terraform_sa_state_bucket" {
  bucket = data.google_storage_bucket.terraform_state.name
  role   = "roles/storage.legacyBucketOwner"
  member = "serviceAccount:${google_service_account.terraform_sa.email}"
}

# 6. Get the Cloud Build service account (auto-created when Cloud Build API is enabled)
data "google_project" "project" {
  project_id = var.project_id
}

# 7. Allow Cloud Build SA to impersonate Terraform SA
resource "google_service_account_iam_member" "cloudbuild_impersonate_terraform" {
  service_account_id = google_service_account.terraform_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

# 8. (Optional) Create Artifact Registry Repository
# This replaces the older GCR and is where your Docker images will live
resource "google_artifact_registry_repository" "app_repo" {
  location      = var.region
  repository_id = "app-images"
  description   = "Docker repository for application images"
  format        = "DOCKER"

  depends_on = [google_project_service.enabled_apis]
}
