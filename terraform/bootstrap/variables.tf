variable "project_id" {
  description = "The GCP Project ID to bootstrap"
  type        = string
}

variable "region" {
  description = "Region for core resources (State bucket, Artifact Registry)"
  type        = string
  default     = "europe-north1"
}

variable "state_bucket_name" {
  description = "Name of the existing Terraform state bucket"
  type        = string
}
