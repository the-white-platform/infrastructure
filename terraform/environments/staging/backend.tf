terraform {
  backend "gcs" {
    bucket = "the-white-platform-terraform-state-staging"
    prefix = "terraform/state/staging"
  }
}
