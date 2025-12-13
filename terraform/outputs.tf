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
    dns_record_type     = "CNAME"
    dns_record_name     = var.domain_name
    dns_record_value    = "ghs.googlehosted.com"
    verification_status = "Check Cloud Run console for domain verification status"
    instructions        = "Add a CNAME record: ${var.domain_name} -> ghs.googlehosted.com"
  } : null
}

output "next_steps" {
  description = "Next steps after deployment"
  value = var.domain_name != "" ? <<-EOT

  ✅ Cloud Run service deployed successfully!

  📋 To complete domain setup for ${var.domain_name}:

  1. Add DNS CNAME record:
     Name:  ${var.domain_name}
     Type:  CNAME
     Value: ghs.googlehosted.com
     TTL:   3600

  2. Verify domain ownership (if first time):
     - Go to: https://console.cloud.google.com/run/domains?project=${var.project_id}
     - Follow the verification steps

  3. Wait for DNS propagation (can take up to 48 hours, usually 5-10 minutes)

  4. Update NEXT_PUBLIC_SERVER_URL secret:
     echo -n "https://${var.domain_name}" | gcloud secrets versions add NEXT_PUBLIC_SERVER_URL_${upper(var.environment)} --data-file=-

  5. Test your domain:
     curl https://${var.domain_name}

  Current Cloud Run URL: ${google_cloud_run_service.main.status[0].url}

  EOT
  : <<-EOT

  ✅ Cloud Run service deployed successfully!

  Service URL: ${google_cloud_run_service.main.status[0].url}

  To add a custom domain later, set domain_name in terraform.tfvars

  EOT
}
