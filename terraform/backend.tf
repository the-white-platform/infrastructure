# Backend configuration for Terraform state
# This will be configured per environment

terraform {
  backend "gcs" {
    # bucket  = "the-white-platform-terraform-state"
    # prefix  = "terraform/state"
    
    # Uncomment and configure these in each environment:
    # - environments/dev/backend.tf
    # - environments/staging/backend.tf
    # - environments/prod/backend.tf
  }
}
