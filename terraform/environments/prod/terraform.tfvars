# Configuration for NEW GCP account (without org policy restrictions)
# Copy this to terraform.tfvars after creating new projects

project_id  = "the-white-prod-481217"
environment = "prod"
region      = "asia-southeast1"

service_name = "fashion-web"

# Container configuration (placeholder - will be updated by Cloud Build)
container_image = "us-docker.pkg.dev/cloudrun/container/hello"
container_port  = 3000

# Resource allocation
memory = "2Gi"
cpu    = "2"

# Scaling configuration
min_instances = 1
max_instances = 10

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
# Note: DATABASE_URI is auto-injected by Cloud SQL when enable_cloud_sql = true
secrets = {
  PAYLOAD_SECRET = {
    secret_name = "PAYLOAD_SECRET"
    version     = "latest"
  }
  NEXT_PUBLIC_SERVER_URL = {
    secret_name = "NEXT_PUBLIC_SERVER_URL"
    version     = "latest"
  }
}

# Labels
labels = {
  environment = "prod"
  team        = "platform"
  managed-by  = "terraform"
}

# Ingress settings
ingress = "all"

# Execution environment
execution_environment = "gen2"

# Cloud SQL
enable_cloud_sql = true

# Vertex AI Virtual Try-On
enable_vertex_vto              = true
vto_bucket_name                = ""
vto_bucket_location            = "asia-southeast1"

# Cloud Armor + Load Balancer
enable_cloud_armor               = true
cloud_armor_rate_limit_threshold = 100
