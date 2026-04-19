################################################################################
# Secret Manager — application runtime secrets for fashion-web on Cloud Run.
#
# Terraform only creates the secret CONTAINERS + replication policy. Values are
# populated out-of-band via `gcloud secrets versions add ...` (see README) so
# the raw secrets never land in Terraform state. Cloud Run reads them via
# `secret_key_ref` in main.tf (driven by the `secrets` tfvar).
################################################################################

locals {
  app_secret_names = [
    "PAYLOAD_SECRET",
    "NEXT_PUBLIC_SERVER_URL",
    "GEMINI_API_KEY",
    "GOOGLE_CLIENT_ID",
    "GOOGLE_CLIENT_SECRET",
    "FACEBOOK_CLIENT_ID",
    "FACEBOOK_CLIENT_SECRET",
    "RESEND_API_KEY",
    "ADMIN_PASSWORD",
    "NEXT_PUBLIC_GA_ID",
    # DATABASE_URI is created elsewhere (sql.tf when Cloud SQL is enabled, or
    # populated manually when pointing at Neon/Supabase). Leave it out here.
  ]
}

resource "google_secret_manager_secret" "app" {
  for_each = toset(local.app_secret_names)

  secret_id = each.key
  project   = var.project_id

  replication {
    auto {}
  }

  labels = {
    environment = var.environment
    managed-by  = "terraform"
  }

  depends_on = [google_project_service.required_apis]
}
