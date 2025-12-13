output "terraform_state_bucket" {
  description = "The GCS bucket used for storing Terraform state"
  value       = data.google_storage_bucket.terraform_state.name
}

output "terraform_service_account" {
  description = "The Service Account email created for Terraform"
  value       = google_service_account.terraform_sa.email
}

output "artifact_registry_repo" {
  description = "The Artifact Registry repository URI"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.app_repo.name}"
}

output "cloud_build_service_account" {
  description = "The Cloud Build service account that can impersonate Terraform SA"
  value       = "${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}

output "next_steps" {
  description = "Instructions for next steps"
  value       = <<EOT

✅ Bootstrap Complete!

The following resources have been configured:
- Terraform State Bucket: ${data.google_storage_bucket.terraform_state.name}
- Terraform Service Account: ${google_service_account.terraform_sa.email}
- Artifact Registry: ${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.app_repo.name}
- Cloud Build SA: ${data.google_project.project.number}@cloudbuild.gserviceaccount.com

Permissions configured:
✅ Terraform SA has full access to state bucket
✅ Cloud Build SA can impersonate Terraform SA
✅ Terraform SA has necessary project-level permissions

Next steps:
1. Update your environment 'backend.tf' files to use the bucket:
   bucket = "${data.google_storage_bucket.terraform_state.name}"

2. Update your 'cloudbuild.yaml' (if needed) to use the Artifact Registry:
   ${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.app_repo.name}

3. Your infrastructure CI/CD is ready to use!

EOT
}
