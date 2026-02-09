# ---------------------------------------------------------------------------------------------------------------------
# CLOUD SQL RESOURCES
# ---------------------------------------------------------------------------------------------------------------------

# Random password generation if not provided
resource "random_password" "db_password" {
  count = var.enable_cloud_sql && var.db_password == "" ? 1 : 0
  length  = 16
  special = false # Avoid special chars that might break URL connection strings easily
}

locals {
  db_password = var.db_password != "" ? var.db_password : (var.enable_cloud_sql ? random_password.db_password[0].result : "")
}

resource "random_id" "db_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "main" {
  count = var.enable_cloud_sql ? 1 : 0

  name             = "${var.service_name}-db-${random_id.db_suffix.hex}"
  database_version = var.db_version
  region           = var.region

  settings {
    tier = var.db_tier
    
    # Enable public IP for now (simplest), restrict via authorized networks if needed
    # Ideally should use Private Service Connect or Private IP with VPC Peering
    ip_configuration {
      ipv4_enabled = true 
    }

     # Automatic backups
    backup_configuration {
      enabled = true
      start_time = "02:00" # 2 AM
    }
    
    # Maintenance window
    maintenance_window {
      day  = 7 # Sunday
      hour = 3 # 3 AM
    }
  }

  deletion_protection = var.environment == "prod" ? true : false

  depends_on = [google_project_service.required_apis]
}

resource "google_sql_database" "main" {
  count = var.enable_cloud_sql ? 1 : 0

  name     = var.db_name
  instance = google_sql_database_instance.main[0].name
}

resource "google_sql_user" "main" {
  count = var.enable_cloud_sql ? 1 : 0

  name     = var.db_user
  instance = google_sql_database_instance.main[0].name
  password = local.db_password
}

# Store the generated DB URL in Secret Manager automatically
resource "google_secret_manager_secret" "generated_db_uri" {
  count = var.enable_cloud_sql ? 1 : 0

  secret_id = "GENERATED_DATABASE_URI_${upper(var.environment)}"
  
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }

  depends_on = [google_project_service.required_apis]
}

resource "google_secret_manager_secret_version" "generated_db_uri" {
  count = var.enable_cloud_sql ? 1 : 0

  secret = google_secret_manager_secret.generated_db_uri[0].id

  # Format: postgres://USER:PASSWORD@/DB_NAME?host=/cloudsql/CONNECTION_NAME
  # Note: When using Cloud Run with Cloud SQL Auth Proxy (built-in via annotation), 
  # the host is a local unix socket at /cloudsql/INSTANCE_CONNECTION_NAME
  secret_data = "postgres://${var.db_user}:${local.db_password}@/${var.db_name}?host=/cloudsql/${google_sql_database_instance.main[0].connection_name}"
}

# Grant access to this new secret
resource "google_secret_manager_secret_iam_member" "generated_db_access" {
  count = var.enable_cloud_sql ? 1 : 0

  secret_id = google_secret_manager_secret.generated_db_uri[0].id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"
}

# Grant Cloud SQL Client role so Cloud Run can connect via Auth Proxy
resource "google_project_iam_member" "cloud_run_cloudsql_client" {
  count = var.enable_cloud_sql ? 1 : 0

  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}
