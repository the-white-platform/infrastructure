# Service Account for Cloud Build (used by triggers)
resource "google_service_account" "cloud_build" {
  account_id   = "cloud-build-${var.environment}"
  display_name = "Cloud Build Service Account for ${var.environment}"
  description  = "Service account used by Cloud Build to deploy fashion-web"
}

# Grant Cloud Build SA permissions to deploy to Cloud Run
resource "google_project_iam_member" "cloud_build_run_admin" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.cloud_build.email}"
}

resource "google_project_iam_member" "cloud_build_sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloud_build.email}"
}

resource "google_project_iam_member" "cloud_build_logs_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloud_build.email}"
}

# Grant Cloud Build SA access to Secret Manager (needed for build-time secrets)
resource "google_project_iam_member" "cloud_build_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloud_build.email}"
}

# Grant Cloud Build SA access to Artifact Registry (needed to push Docker images)
resource "google_project_iam_member" "cloud_build_artifact_registry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.cloud_build.email}"
}

# Cloud Build Trigger for production (tag-based deployment)
# DISABLED: All deployments now happen via GitHub Actions only
# This trigger deploys to production when a version tag (e.g., v1.0.0) is created on main branch
# Note: Repository must be connected to Cloud Build first
resource "google_cloudbuild_trigger" "fashion_web_deploy_tag" {
  count       = var.environment == "prod" ? 1 : 0
  name        = "fashion-web-deploy-prod-tag"
  description = "Deploy fashion-web to production on tag creation (e.g., v1.0.0) after merge to main"
  location    = var.region
  disabled    = true  # Disabled - GitHub Actions handles all deployments

  github {
    owner = "the-white-platform"
    name  = "fashion-web"
    push {
      tag = "^v[0-9]+\\.[0-9]+\\.[0-9]+$"  # Matches v1.0.0, v2.1.3, etc.
    }
  }

  filename = "cloudbuild.yaml"

  substitutions = {
    _NEXT_PUBLIC_SERVER_URL = var.domain_name != "" ? "https://${var.domain_name}" : google_cloud_run_service.main.status[0].url
    _REGION                 = var.region
  }

  service_account = google_service_account.cloud_build.id
}

# Cloud Build Trigger for dev (PR-based deployment to main)
# DISABLED: All deployments now happen via GitHub Actions only
resource "google_cloudbuild_trigger" "fashion_web_deploy_pr" {
  count       = var.environment == "dev" ? 1 : 0
  name        = "fashion-web-deploy-dev-pr"
  description = "Deploy fashion-web to dev when PR is created/updated targeting main branch"
  location    = var.region
  disabled    = true  # Disabled - GitHub Actions handles all deployments

  github {
    owner = "the-white-platform"
    name  = "fashion-web"
    pull_request {
      branch          = "^main$"
      comment_control = "COMMENTS_ENABLED_FOR_EXTERNAL_CONTRIBUTORS_ONLY"
    }
  }

  filename = "cloudbuild.yaml"

  substitutions = {
    _NEXT_PUBLIC_SERVER_URL = var.domain_name != "" ? "https://${var.domain_name}" : google_cloud_run_service.main.status[0].url
    _REGION                 = var.region
  }

  service_account = google_service_account.cloud_build.id
}

# Manual trigger for both environments
# DISABLED: All deployments now happen via GitHub Actions only
resource "google_cloudbuild_trigger" "fashion_web_deploy_manual" {
  name        = "fashion-web-deploy-${var.environment}-manual"
  description = "Manually trigger deployment to ${var.environment} from main branch"
  location    = var.region
  disabled    = true  # Disabled - GitHub Actions handles all deployments

  # Manual triggers don't have a source trigger
  source_to_build {
    uri       = "https://github.com/the-white-platform/fashion-web"
    ref       = "refs/heads/main"  # Always use main branch for manual triggers
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild.yaml"
    uri       = "https://github.com/the-white-platform/fashion-web"
    revision  = "refs/heads/main"  # Always use main branch for manual triggers
    repo_type = "GITHUB"
  }

  substitutions = {
    _NEXT_PUBLIC_SERVER_URL = var.domain_name != "" ? "https://${var.domain_name}" : google_cloud_run_service.main.status[0].url
    _REGION                 = var.region
  }

  service_account = google_service_account.cloud_build.id
}
