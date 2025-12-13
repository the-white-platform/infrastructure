variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "europe-north1"
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
  default     = "gcr.io/PROJECT_ID/fashion-web:latest"
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
  default     = true
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
