terraform {
  backend "gcs" {
    bucket = "the-white-prod-terraform-state"
    prefix = "terraform/state/prod"
  }
}
