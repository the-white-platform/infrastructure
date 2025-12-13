terraform {
  backend "gcs" {
    bucket = "the-white-platform-terraform-state-prod"
    prefix = "terraform/state/prod"
  }
}
