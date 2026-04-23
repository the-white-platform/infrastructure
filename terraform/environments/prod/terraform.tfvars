# Configuration for NEW GCP account (without org policy restrictions)
# Copy this to terraform.tfvars after creating new projects

project_id  = "the-white-prod-481217"
environment = "prod"
region      = "asia-southeast1"

service_name = "fashion-web"

# Container configuration (placeholder - will be updated by Cloud Build)
container_image = "us-docker.pkg.dev/cloudrun/container/hello"
container_port  = 3000

# Resource allocation (downsized — 1 vCPU is enough for small store)
memory = "1Gi"
cpu    = "1"

# Scaling configuration. Keep 1 warm instance so admin login + API
# requests don't hit the 100+ second cold-start stalls we saw on
# 2026-04-22 and 2026-04-23 — Payload auth initialization against
# Cloud SQL on a freshly-spawned container is the slow path, not
# the code itself. ~500K VND/month premium is cheaper than being
# offline from cold-start whenever traffic dips.
min_instances = 1
max_instances = 5

# Timeout
timeout_seconds = 300

# Access control - CAN SET TO TRUE IN NEW ACCOUNT! 🎉
allow_unauthenticated = true

# Custom domain
domain_name = "thewhite.cool" # Update with your production domain

# Monitoring
enable_monitoring = true

# Environment variables (non-sensitive — safe to bake into the revision)
env_vars = {
  NODE_ENV                = "production"
  NEXT_TELEMETRY_DISABLED = "1"
  GCP_PROJECT_ID          = "the-white-prod-481217"
  GCP_REGION              = "asia-southeast1"
  ADMIN_EMAIL             = "admin@thewhite.cool"
  PAYLOAD_MEDIA_BUCKET    = "the-white-prod-481217-payload-media" # read by storage-gcs adapter
}

# Secrets from Secret Manager — containers are created by secrets.tf.
# Values are populated out-of-band (`gcloud secrets versions add …`) so no
# plaintext lives in Terraform state.
# Database is Neon (free tier) — connection string stored as DATABASE_URI.
secrets = {
  DATABASE_URI = {
    secret_name = "DATABASE_URI"
    version     = "latest"
  }
  PAYLOAD_SECRET = {
    secret_name = "PAYLOAD_SECRET"
    version     = "latest"
  }
  NEXT_PUBLIC_SERVER_URL = {
    secret_name = "NEXT_PUBLIC_SERVER_URL"
    version     = "latest"
  }
  GEMINI_API_KEY = {
    secret_name = "GEMINI_API_KEY"
    version     = "latest"
  }
  GOOGLE_CLIENT_ID = {
    secret_name = "GOOGLE_CLIENT_ID"
    version     = "latest"
  }
  GOOGLE_CLIENT_SECRET = {
    secret_name = "GOOGLE_CLIENT_SECRET"
    version     = "latest"
  }
  FACEBOOK_CLIENT_ID = {
    secret_name = "FACEBOOK_CLIENT_ID"
    version     = "latest"
  }
  FACEBOOK_CLIENT_SECRET = {
    secret_name = "FACEBOOK_CLIENT_SECRET"
    version     = "latest"
  }
  RESEND_API_KEY = {
    secret_name = "RESEND_API_KEY"
    version     = "latest"
  }
  ADMIN_PASSWORD = {
    secret_name = "ADMIN_PASSWORD"
    version     = "latest"
  }
  NEXT_PUBLIC_GA_ID = {
    secret_name = "NEXT_PUBLIC_GA_ID"
    version     = "latest"
  }
}

# Labels
labels = {
  environment = "prod"
  team        = "platform"
  managed-by  = "terraform"
}

# Ingress settings (direct access — no load balancer)
ingress = "all"

# Execution environment
execution_environment = "gen2"

# Cloud SQL — enabled for stable Postgres without the Supabase pooler issues
# (drizzle prepared-statement bugs, ~30-client cap on session pool). Smallest
# tier; keep an eye on spend.
enable_cloud_sql = true

# Vertex AI Virtual Try-On (replaced by Gemini Flash — free tier)
enable_vertex_vto   = false
vto_bucket_name     = ""
vto_bucket_location = "asia-southeast1"

# Cloud Armor + Load Balancer (disabled — saves ~330K VND/month)
# Cloud Run has built-in HTTPS at *.run.app, use custom domain mapping instead
enable_cloud_armor               = false
cloud_armor_rate_limit_threshold = 100

# Billing
billing_account_id = "015F7D-99EE6C-0A30FB"

# Payload CMS media bucket
enable_payload_media_bucket = true
payload_media_bucket_name   = "" # empty → defaults to <project>-payload-media
