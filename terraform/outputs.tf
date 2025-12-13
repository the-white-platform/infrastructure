output "service_url" {
  description = "URL of the deployed Cloud Run service"
  value       = google_cloud_run_service.main.status[0].url
}

output "service_name" {
  description = "Name of the Cloud Run service"
  value       = google_cloud_run_service.main.name
}

output "service_id" {
  description = "ID of the Cloud Run service"
  value       = google_cloud_run_service.main.id
}

output "service_location" {
  description = "Location of the Cloud Run service"
  value       = google_cloud_run_service.main.location
}

output "service_account_email" {
  description = "Email of the service account used by Cloud Run"
  value       = google_service_account.cloud_run.email
}

output "custom_domain" {
  description = "Custom domain mapping (if configured)"
  value       = var.domain_name != "" ? var.domain_name : null
}

output "latest_revision" {
  description = "Latest revision name"
  value       = google_cloud_run_service.main.status[0].latest_ready_revision_name
}

output "project_id" {
  description = "GCP Project ID"
  value       = var.project_id
}

output "region" {
  description = "GCP Region"
  value       = var.region
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}
