terraform {
  backend "gcs" {
    bucket = "the-white-platform-terraform-state-dev-481217"
    prefix = "terraform/state/dev"
  }
}
