# Enable required APIs
resource "google_project_service" "required_apis" {
  for_each = toset([
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "secretmanager.googleapis.com",
    "containerregistry.googleapis.com",
    "artifactregistry.googleapis.com", # For Docker image storage
    "compute.googleapis.com",
    "vpcaccess.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
    "sqladmin.googleapis.com",
    "certificatemanager.googleapis.com", # For SSL certificates
    "iam.googleapis.com",                # For Workload Identity Federation
    "aiplatform.googleapis.com",         # For Vertex AI Virtual Try-On
    "billingbudgets.googleapis.com",     # For budget alerts
  ])

  service            = each.value
  disable_on_destroy = false
}

# Cloud Run Service
resource "google_cloud_run_service" "main" {
  name     = var.service_name
  location = var.region

  template {
    spec {
      containers {
        image = var.container_image

        ports {
          container_port = var.container_port
        }

        resources {
          limits = {
            cpu    = var.cpu
            memory = var.memory
          }
        }

        # Environment variables
        dynamic "env" {
          for_each = merge(
            var.env_vars,
            {
              NODE_ENV                = "production"
              NEXT_TELEMETRY_DISABLED = "1"
            }
          )
          content {
            name  = env.key
            value = env.value
          }
        }

        # Auto-inject DATABASE_URI if Cloud SQL is enabled
        dynamic "env" {
          for_each = var.enable_cloud_sql ? [1] : []
          content {
            name = "DATABASE_URI"
            value_from {
              secret_key_ref {
                name = google_secret_manager_secret.generated_db_uri[0].secret_id
                key  = "latest"
              }
            }
          }
        }

        # Secrets from Secret Manager
        dynamic "env" {
          for_each = var.secrets
          content {
            name = env.key
            value_from {
              secret_key_ref {
                name = env.value.secret_name
                key  = env.value.version
              }
            }
          }
        }
      }

      container_concurrency = 80
      timeout_seconds       = var.timeout_seconds
      service_account_name  = google_service_account.cloud_run.email
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale"         = tostring(var.min_instances)
        "autoscaling.knative.dev/maxScale"         = tostring(var.max_instances)
        "run.googleapis.com/execution-environment" = var.execution_environment
        # CPU throttling stays on (default). min_instances=1 keeps
        # a warm container alive (DB pool intact, post-cold-JIT
        # state in memory) so the first request after idle is a
        # ~3-5 s throttled-CPU hit instead of the 100+ s cold
        # start we saw on 2026-04-22 / 2026-04-23. Full
        # always-allocated CPU costs ~5× more per month and the
        # extra few seconds don't matter for the admin UX.

        # VPC connector if specified
        "run.googleapis.com/vpc-access-connector" = var.vpc_connector_name != "" ? var.vpc_connector_name : null
        "run.googleapis.com/vpc-access-egress"    = var.vpc_connector_name != "" ? "private-ranges-only" : null

        # Cloud SQL connections
        "run.googleapis.com/cloudsql-instances" = var.enable_cloud_sql ? google_sql_database_instance.main[0].connection_name : (length(var.cloudsql_instances) > 0 ? join(",", var.cloudsql_instances) : null)
      }

      labels = merge(
        var.labels,
        {
          environment = var.environment
          managed-by  = "terraform"
        }
      )
    }
  }

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = var.enable_cloud_armor ? "internal-and-cloud-load-balancing" : var.ingress
    }

    labels = merge(
      var.labels,
      {
        environment = var.environment
        managed-by  = "terraform"
      }
    )
  }

  lifecycle {
    ignore_changes = [
      template[0].spec[0].containers[0].image,
      metadata[0].annotations["client.knative.dev/user-image"],
      metadata[0].annotations["run.googleapis.com/client-name"],
      metadata[0].annotations["run.googleapis.com/client-version"]
    ]
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true

  depends_on = [
    google_project_service.required_apis,
    google_service_account.cloud_run
  ]
}

# Service Account for Cloud Run
resource "google_service_account" "cloud_run" {
  account_id   = "${var.service_name}-sa"
  display_name = "Service Account for ${var.service_name}"
  description  = "Service account used by Cloud Run service ${var.service_name}"
}

# IAM binding to allow public access (if enabled)
resource "google_cloud_run_service_iam_member" "public_access" {
  count = var.allow_unauthenticated ? 1 : 0

  service  = google_cloud_run_service.main.name
  location = google_cloud_run_service.main.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Grant Cloud Run service account access to Secret Manager
resource "google_secret_manager_secret_iam_member" "cloud_run_secret_access" {
  for_each = var.secrets

  secret_id = each.value.secret_name
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"
}

# Custom domain mapping (if domain is specified)
resource "google_cloud_run_domain_mapping" "main" {
  count = var.domain_name != "" && !var.enable_cloud_armor ? 1 : 0

  location = var.region
  name     = var.domain_name

  metadata {
    namespace = var.project_id
    labels = {
      environment = var.environment
    }
  }

  spec {
    route_name     = google_cloud_run_service.main.name
    force_override = true # Force override if domain is mapped elsewhere
  }
}

# Monitoring: Uptime check
resource "google_monitoring_uptime_check_config" "main" {
  count = var.enable_monitoring ? 1 : 0

  display_name = "${var.service_name}-uptime-check"
  timeout      = "10s"
  period       = "60s"

  http_check {
    path         = "/"
    port         = 443
    use_ssl      = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = var.domain_name != "" ? var.domain_name : replace(google_cloud_run_service.main.status[0].url, "/^https?:///", "")
    }
  }

  depends_on = [google_cloud_run_service.main]
}

# Monitoring: Alert policy for high error rate
resource "google_monitoring_alert_policy" "high_error_rate" {
  count = var.enable_monitoring ? 1 : 0

  display_name = "${var.service_name}-high-error-rate"
  combiner     = "OR"

  conditions {
    display_name = "Error rate above 5%"

    condition_threshold {
      filter          = "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${var.service_name}\" AND metric.type=\"run.googleapis.com/request_count\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.05

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }

  notification_channels = []

  alert_strategy {
    auto_close = "1800s"
  }
}

# Monitoring: Alert policy for high latency
resource "google_monitoring_alert_policy" "high_latency" {
  count = var.enable_monitoring ? 1 : 0

  display_name = "${var.service_name}-high-latency"
  combiner     = "OR"

  conditions {
    display_name = "Request latency above 2 seconds"

    condition_threshold {
      filter          = "resource.type=\"cloud_run_revision\" AND resource.labels.service_name=\"${var.service_name}\" AND metric.type=\"run.googleapis.com/request_latencies\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 2000

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_DELTA"
        cross_series_reducer = "REDUCE_PERCENTILE_95"
      }
    }
  }

  notification_channels = []

  alert_strategy {
    auto_close = "1800s"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# VERTEX AI VIRTUAL TRY-ON (VTO) RESOURCES
# ---------------------------------------------------------------------------------------------------------------------

# GCS bucket for VTO images
resource "google_storage_bucket" "vto_images" {
  count = var.enable_vertex_vto ? 1 : 0

  name     = var.vto_bucket_name != "" ? var.vto_bucket_name : "${var.project_id}-vto-images"
  location = var.vto_bucket_location
  project  = var.project_id

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  lifecycle_rule {
    condition {
      age = var.vto_image_retention_days
    }
    action {
      type = "Delete"
    }
  }

  labels = merge(
    var.labels,
    {
      environment = var.environment
      managed-by  = "terraform"
      purpose     = "vto-images"
    }
  )

  depends_on = [google_project_service.required_apis]
}

# Grant Vertex AI user role to Cloud Run service account.
# Unconditionally applied: Vertex AI now backs the Wolfies chat, the
# Smart Size Picker, and VTO image generation — it is no longer an
# optional feature. The `enable_vertex_vto` flag still gates the
# (unused) GCS bucket resources below.
resource "google_project_iam_member" "cloud_run_vertex_ai_user" {
  project = var.project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

# Grant Storage Object Admin on VTO bucket to Cloud Run service account
resource "google_storage_bucket_iam_member" "cloud_run_vto_bucket_admin" {
  count = var.enable_vertex_vto ? 1 : 0

  bucket = google_storage_bucket.vto_images[0].name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.cloud_run.email}"
}

# Grant Token Creator role to Cloud Run SA on itself (needed for V4 signed URLs)
resource "google_service_account_iam_member" "cloud_run_token_creator" {
  count              = var.enable_vertex_vto ? 1 : 0
  service_account_id = google_service_account.cloud_run.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${google_service_account.cloud_run.email}"
}
