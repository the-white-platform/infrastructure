output "terraform_state_bucket" {
  description = "The GCS bucket created for storing Terraform state"
  value       = google_storage_bucket.terraform_state.name
}

output "terraform_service_account" {
  description = "The Service Account email created for Terraform"
  value       = google_service_account.terraform_sa.email
}

output "artifact_registry_repo" {
  description = "The Artifact Registry repository URI"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.app_repo.name}"
}

output "next_steps" {
  description = "Instructions for next steps"
  value       = <<EOT

✅ Bootstrap Complete!

1. Update your environment 'backend.tf' files to use the new bucket:
   bucket = "${google_storage_bucket.terraform_state.name}"

2. Update your 'cloudbuild.yaml' (if needed) to use the new Artifact Registry:
   ${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.app_repo.name}

EOT
}
