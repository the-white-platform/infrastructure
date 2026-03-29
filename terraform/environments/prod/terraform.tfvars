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

# Scaling configuration (min=0 saves ~500K VND/month — cold start is ~2-3s)
min_instances = 0
max_instances = 5

# Timeout
timeout_seconds = 300

# Access control - CAN SET TO TRUE IN NEW ACCOUNT! 🎉
allow_unauthenticated = true

# Custom domain
domain_name = "thewhite.cool"  # Update with your production domain

# Monitoring
enable_monitoring = true

# Environment variables
env_vars = {
  NODE_ENV                 = "production"
  NEXT_TELEMETRY_DISABLED = "1"
  GCP_PROJECT_ID           = "the-white-prod-481217"
  GCP_REGION               = "asia-southeast1"
  VTO_BUCKET_NAME          = "the-white-prod-481217-vto-images"
}

# Secrets from Secret Manager
# Database is now Neon (free tier) — connection string in Secret Manager
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

# Cloud SQL (replaced by Neon free-tier PostgreSQL)
enable_cloud_sql = false

# Vertex AI Virtual Try-On (replaced by Gemini Flash — free tier)
enable_vertex_vto              = false
vto_bucket_name                = ""
vto_bucket_location            = "asia-southeast1"

# Cloud Armor + Load Balancer (disabled — saves ~330K VND/month)
# Cloud Run has built-in HTTPS at *.run.app, use custom domain mapping instead
enable_cloud_armor               = false
cloud_armor_rate_limit_threshold = 100

# Billing
billing_account_id = "015F7D-99EE6C-0A30FB"
