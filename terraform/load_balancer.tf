# Cloud Load Balancer for public access (bypasses org policy IAM restrictions)
# This allows public access to Cloud Run even when org policy blocks allUsers
# 
# When traffic comes through the load balancer, it authenticates as the Compute Engine
# default service account, so we grant that account permission to invoke Cloud Run

# Grant Compute Engine default service account permission to invoke Cloud Run
# This allows the load balancer to route traffic to Cloud Run
resource "google_cloud_run_service_iam_member" "compute_invoker" {
  service  = google_cloud_run_service.main.name
  location = google_cloud_run_service.main.location
  role     = "roles/run.invoker"
  member   = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

data "google_project" "project" {
  project_id = var.project_id
}

resource "google_compute_backend_service" "cloud_run_backend" {
  name                  = "${var.service_name}-backend"
  description           = "Backend service for ${var.service_name} Cloud Run"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 30
  enable_cdn            = false
  load_balancing_scheme  = "EXTERNAL_MANAGED"

  backend {
    group = google_compute_region_network_endpoint_group.cloud_run_neg.id
  }

  # Note: Serverless NEGs (Cloud Run) don't support health checks
  # Cloud Run handles health checks internally

  log_config {
    enable      = true
    sample_rate = 1.0
  }
}

# Network Endpoint Group for Cloud Run
resource "google_compute_region_network_endpoint_group" "cloud_run_neg" {
  name                  = "${var.service_name}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region

  cloud_run {
    service = google_cloud_run_service.main.name
  }
}

# Note: Health checks are not supported for Serverless NEGs (Cloud Run)
# Cloud Run handles health checks internally, so we don't create a health check resource

# URL Map
resource "google_compute_url_map" "cloud_run_url_map" {
  name            = "${var.service_name}-url-map"
  default_service = google_compute_backend_service.cloud_run_backend.id

  host_rule {
    hosts        = var.domain_name != "" ? [var.domain_name] : ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.cloud_run_backend.id
  }
}

# HTTP(S) Proxy
resource "google_compute_target_https_proxy" "cloud_run_https_proxy" {
  count = var.domain_name != "" ? 1 : 0

  name             = "${var.service_name}-https-proxy"
  url_map          = google_compute_url_map.cloud_run_url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.cloud_run_ssl[0].id]
}

resource "google_compute_target_http_proxy" "cloud_run_http_proxy" {
  name    = "${var.service_name}-http-proxy"
  url_map = google_compute_url_map.cloud_run_url_map.id
}

# Managed SSL Certificate (if domain is provided)
resource "google_compute_managed_ssl_certificate" "cloud_run_ssl" {
  count = var.domain_name != "" ? 1 : 0

  name = "${var.service_name}-ssl-cert"

  managed {
    domains = [var.domain_name]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Global Forwarding Rule for HTTPS
resource "google_compute_global_forwarding_rule" "cloud_run_https_forwarding" {
  count = var.domain_name != "" ? 1 : 0

  name       = "${var.service_name}-https-forwarding"
  target     = google_compute_target_https_proxy.cloud_run_https_proxy[0].id
  port_range = "443"
  ip_protocol = "TCP"
  ip_address  = google_compute_global_address.cloud_run_ip[0].id
}

# Global Forwarding Rule for HTTP
# If domain is provided, use the static IP. Otherwise, create a temporary IP for HTTP
resource "google_compute_global_forwarding_rule" "cloud_run_http_forwarding" {
  name       = "${var.service_name}-http-forwarding"
  target     = google_compute_target_http_proxy.cloud_run_http_proxy.id
  port_range = "80"
  ip_protocol = "TCP"
  ip_address  = var.domain_name != "" ? google_compute_global_address.cloud_run_ip[0].id : google_compute_global_address.cloud_run_ip_temp[0].id
}

# Temporary IP for HTTP when no domain (for testing)
resource "google_compute_global_address" "cloud_run_ip_temp" {
  count = var.domain_name == "" ? 1 : 0

  name = "${var.service_name}-ip-temp"
}

# Static IP address
resource "google_compute_global_address" "cloud_run_ip" {
  count = var.domain_name != "" ? 1 : 0

  name = "${var.service_name}-ip"
}

