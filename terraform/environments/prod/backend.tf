terraform {
  backend "gcs" {
    bucket = "the-white-prod-terraform-state-481217"
    prefix = "terraform/state/prod"
  }
}
