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

output "domain_mapping_status" {
  description = "Domain mapping status and DNS configuration"
  value = var.domain_name != "" ? {
    domain              = var.domain_name
    cloud_run_url       = google_cloud_run_service.main.status[0].url
    dns_records         = !var.enable_cloud_armor ? google_cloud_run_domain_mapping.main[0].status[0].resource_records : []
    verification_status = var.enable_cloud_armor ? "Domain routed via Global HTTPS Load Balancer" : "Check Cloud Run console for domain verification status"
    instructions        = var.enable_cloud_armor ? "Add A record pointing to Load Balancer IP" : "Add the DNS records shown in dns_records to your DNS provider"
  } : null
}

output "load_balancer_ip" {
  description = "Global static IP address of the HTTPS Load Balancer (when Cloud Armor is enabled)"
  value       = var.enable_cloud_armor ? google_compute_global_address.main[0].address : null
}

output "next_steps" {
  description = "Next steps after deployment"
  value       = var.domain_name != "" ? (var.enable_cloud_armor ? "Domain configured: https://${var.domain_name} - Ensure A record points to LB IP: ${google_compute_global_address.main[0].address}" : "Domain configured: https://${var.domain_name} - Add CNAME record pointing to ghs.googlehosted.com") : "Service deployed at: ${google_cloud_run_service.main.status[0].url}"
}

# ---------------------------------------------------------------------------------------------------------------------
# VERTEX AI VIRTUAL TRY-ON (VTO) OUTPUTS
# ---------------------------------------------------------------------------------------------------------------------

output "vto_bucket_name" {
  description = "Name of the GCS bucket for VTO images"
  value       = var.enable_vertex_vto ? google_storage_bucket.vto_images[0].name : null
}

output "vto_vertex_endpoint" {
  description = "Vertex AI API endpoint for the configured region"
  value       = var.enable_vertex_vto ? "https://${var.region}-aiplatform.googleapis.com" : null
}
