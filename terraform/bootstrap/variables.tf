variable "project_id" {
  description = "The GCP Project ID to bootstrap"
  type        = string
}

variable "region" {
  description = "Region for core resources (State bucket, Artifact Registry)"
  type        = string
  default     = "europe-north1"
}
