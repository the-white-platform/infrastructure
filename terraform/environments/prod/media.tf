################################################################################
# GCS bucket for Payload CMS media uploads (product images, user review photos,
# etc). Cloud Run's container filesystem is ephemeral — each deploy/restart
# wipes local `public/media/`. This bucket gives uploads a persistent home.
#
# fashion-web is configured via @payloadcms/storage-gcs to write/read from here.
# Files are served publicly so <Image> / <img> tags load directly from
# https://storage.googleapis.com/<bucket>/<path>.
################################################################################

resource "google_storage_bucket" "payload_media" {
  count = var.enable_payload_media_bucket ? 1 : 0

  name     = var.payload_media_bucket_name != "" ? var.payload_media_bucket_name : "${var.project_id}-payload-media"
  location = var.region
  project  = var.project_id

  uniform_bucket_level_access = true
  public_access_prevention    = "inherited"
  force_destroy               = false

  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD"]
    response_header = ["Content-Type"]
    max_age_seconds = 3600
  }

  labels = merge(
    var.labels,
    {
      environment = var.environment
      managed-by  = "terraform"
      purpose     = "payload-media"
    }
  )

  depends_on = [google_project_service.required_apis]
}

# Publicly readable — product images, etc. are served as public URLs.
resource "google_storage_bucket_iam_member" "payload_media_public_read" {
  count  = var.enable_payload_media_bucket ? 1 : 0
  bucket = google_storage_bucket.payload_media[0].name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# Cloud Run SA can upload/update/delete objects in the bucket.
resource "google_storage_bucket_iam_member" "payload_media_cloud_run_admin" {
  count  = var.enable_payload_media_bucket ? 1 : 0
  bucket = google_storage_bucket.payload_media[0].name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.cloud_run.email}"
}
