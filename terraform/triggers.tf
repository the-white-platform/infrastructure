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

# Cloud Build Trigger for production (tag-based deployment)
resource "google_cloudbuild_trigger" "fashion_web_deploy_tag" {
  count       = var.environment == "prod" ? 1 : 0
  name        = "fashion-web-deploy-prod-tag"
  description = "Deploy fashion-web to production on tag creation (e.g., v1.0.0)"
  location    = var.region

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
    _ENVIRONMENT            = "production"
  }

  service_account = google_service_account.cloud_build.id
}

# Cloud Build Trigger for dev (PR-based deployment)
resource "google_cloudbuild_trigger" "fashion_web_deploy_pr" {
  count       = var.environment == "dev" ? 1 : 0
  name        = "fashion-web-deploy-dev-pr"
  description = "Deploy fashion-web to dev on PR creation/update"
  location    = var.region

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
    _ENVIRONMENT            = "dev"
  }

  service_account = google_service_account.cloud_build.id
}

# Cloud Build Trigger for dev (push to develop branch)
resource "google_cloudbuild_trigger" "fashion_web_deploy_develop" {
  count       = var.environment == "dev" ? 1 : 0
  name        = "fashion-web-deploy-dev-push"
  description = "Deploy fashion-web to dev on push to develop branch"
  location    = var.region

  github {
    owner = "the-white-platform"
    name  = "fashion-web"
    push {
      branch = "^develop$"
    }
  }

  filename = "cloudbuild.yaml"

  substitutions = {
    _NEXT_PUBLIC_SERVER_URL = var.domain_name != "" ? "https://${var.domain_name}" : google_cloud_run_service.main.status[0].url
    _ENVIRONMENT            = "dev"
  }

  service_account = google_service_account.cloud_build.id
}

# Manual trigger for both environments
resource "google_cloudbuild_trigger" "fashion_web_deploy_manual" {
  name        = "fashion-web-deploy-${var.environment}-manual"
  description = "Manually trigger deployment to ${var.environment}"
  location    = var.region
  disabled    = false

  # Manual triggers don't have a source trigger
  source_to_build {
    uri       = "https://github.com/the-white-platform/fashion-web"
    ref       = var.environment == "prod" ? "refs/heads/main" : "refs/heads/develop"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "cloudbuild.yaml"
    uri       = "https://github.com/the-white-platform/fashion-web"
    revision  = var.environment == "prod" ? "refs/heads/main" : "refs/heads/develop"
    repo_type = "GITHUB"
  }

  substitutions = {
    _NEXT_PUBLIC_SERVER_URL = var.domain_name != "" ? "https://${var.domain_name}" : google_cloud_run_service.main.status[0].url
    _ENVIRONMENT            = var.environment
  }

  service_account = google_service_account.cloud_build.id
}
