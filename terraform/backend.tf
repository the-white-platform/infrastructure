# Backend configuration for Terraform state
# This will be configured per environment

terraform {
  backend "gcs" {
    # bucket  = "the-white-platform-terraform-state"
    # prefix  = "terraform/state"
    
    # Uncomment and configure in:
    # - environments/prod/backend.tf
  }
}
