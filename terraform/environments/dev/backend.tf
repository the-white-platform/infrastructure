terraform {
  backend "gcs" {
    bucket = "the-white-platform-terraform-state-dev"
    prefix = "terraform/state/dev"
  }
}
