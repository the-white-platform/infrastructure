variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "asia-southeast1" # Singapore - closest to Vietnam
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
  default     = "fashion-web"
}

variable "container_image" {
  description = "Container image URL"
  type        = string
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 3000
}

variable "memory" {
  description = "Memory allocation for Cloud Run service"
  type        = string
  default     = "2Gi"
}

variable "cpu" {
  description = "CPU allocation for Cloud Run service"
  type        = string
  default     = "2"
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 10
}

variable "timeout_seconds" {
  description = "Request timeout in seconds"
  type        = number
  default     = 300
}

variable "allow_unauthenticated" {
  description = "Allow unauthenticated access to the service"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Custom domain name for the service"
  type        = string
  default     = ""
}

variable "enable_cdn" {
  description = "Enable Cloud CDN"
  type        = bool
  default     = false
}

variable "enable_monitoring" {
  description = "Enable enhanced monitoring and alerting"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)
  default     = {}
}

variable "env_vars" {
  description = "Environment variables for the service"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Secret Manager secrets to mount"
  type = map(object({
    secret_name = string
    version     = string
  }))
  default = {}
}

variable "vpc_connector_name" {
  description = "VPC connector name for private networking"
  type        = string
  default     = ""
}

variable "cloudsql_instances" {
  description = "Cloud SQL instances to connect to"
  type        = list(string)
  default     = []
}

variable "ingress" {
  description = "Ingress settings (all, internal, internal-and-cloud-load-balancing)"
  type        = string
  default     = "all"
}

variable "execution_environment" {
  description = "Execution environment (gen1 or gen2)"
  type        = string
  default     = "gen2"
}

# ---------------------------------------------------------------------------------------------------------------------
# CLOUD ARMOR / LOAD BALANCER CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

variable "enable_cloud_armor" {
  description = "Enable Cloud Armor security policy and Global HTTPS Load Balancer"
  type        = bool
  default     = false
}

variable "cloud_armor_rate_limit_threshold" {
  description = "Maximum requests per minute per IP before rate limiting (Cloud Armor)"
  type        = number
  default     = 100
}

# ---------------------------------------------------------------------------------------------------------------------
# CLOUD SQL CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

variable "enable_cloud_sql" {
  description = "Enable Cloud SQL instance creation"
  type        = bool
  default     = true
}

variable "db_tier" {
  description = "The machine type to use for the database (e.g., db-f1-micro, db-custom-1-3840)"
  type        = string
  default     = "db-f1-micro" # Cheapest option for dev
}

variable "db_version" {
  description = "The database version to use"
  type        = string
  default     = "POSTGRES_15"
}

variable "db_name" {
  description = "The name of the default database to create"
  type        = string
  default     = "fashion_db"
}

variable "db_user" {
  description = "The name of the default database user"
  type        = string
  default     = "fashion_user"
}

variable "db_password" {
  description = "The password for the default database user"
  type        = string
  sensitive   = true
  default     = "" # If empty, a random one will be generated
}

# ---------------------------------------------------------------------------------------------------------------------
# VERTEX AI VIRTUAL TRY-ON (VTO) CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

variable "enable_vertex_vto" {
  description = "Enable Vertex AI Virtual Try-On resources"
  type        = bool
  default     = false
}

variable "vto_bucket_name" {
  description = "Name of the GCS bucket for VTO images"
  type        = string
  default     = ""
}

variable "vto_bucket_location" {
  description = "Location for the VTO GCS bucket"
  type        = string
  default     = "asia-southeast1"
}

variable "vto_image_retention_days" {
  description = "Days before VTO images are auto-deleted from GCS"
  type        = number
  default     = 30
}

variable "vto_budget_amount" {
  description = "Monthly budget alert threshold in USD for Vertex AI spend"
  type        = number
  default     = 50
}

variable "billing_account_id" {
  description = "GCP billing account ID for budget alerts"
  type        = string
}

variable "budget_alert_email" {
  description = "Email address for budget alert notifications (leave empty to disable)"
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------
# Payload CMS media bucket (persists uploads across Cloud Run deploys)
# ---------------------------------------------------------------------------

variable "enable_payload_media_bucket" {
  description = "Create a GCS bucket for Payload CMS media uploads"
  type        = bool
  default     = true
}

variable "payload_media_bucket_name" {
  description = "GCS bucket name for Payload media (defaults to <project>-payload-media)"
  type        = string
  default     = ""
}
