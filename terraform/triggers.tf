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

# Cloud Build Trigger for fashion-web deployment
resource "google_cloudbuild_trigger" "fashion_web_deploy" {
  name        = "fashion-web-deploy-${var.environment}"
  description = "Deploy fashion-web app on push to main/staging/develop for ${var.environment}"
  location    = var.region

  github {
    owner = "the-white-platform"
    name  = "fashion-web"
    push {
      branch = "^main$|^staging$|^develop$"
    }
  }

  filename = "cloudbuild.yaml"

  substitutions = {
    _NEXT_PUBLIC_SERVER_URL = var.domain_name != "" ? "https://${var.domain_name}" : google_cloud_run_service.main.status[0].url
  }

  service_account = google_service_account.cloud_build.id
}
