variable "project_id" {
  description = "The GCP Project ID to bootstrap"
  type        = string
}

variable "region" {
  description = "Region for core resources (State bucket, Artifact Registry)"
  type        = string
  default     = "asia-southeast1"  # Singapore - closest to Vietnam
}

variable "state_bucket_name" {
  description = "Name of the existing Terraform state bucket"
  type        = string
}
