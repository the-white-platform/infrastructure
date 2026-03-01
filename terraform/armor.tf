# ---------------------------------------------------------------------------------------------------------------------
# CLOUD ARMOR + GLOBAL HTTPS LOAD BALANCER FOR DDOS PROTECTION
# All resources gated on var.enable_cloud_armor
# ---------------------------------------------------------------------------------------------------------------------

# Cloud Armor security policy
resource "google_compute_security_policy" "main" {
  count = var.enable_cloud_armor ? 1 : 0

  name        = "${var.service_name}-security-policy"
  description = "Cloud Armor security policy for ${var.service_name}"

  # Default rule: allow all traffic
  rule {
    action   = "allow"
    priority = 2147483647
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default allow rule"
  }

  # Rate limiting rule
  rule {
    action   = "throttle"
    priority = 1000
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Rate limit: ${var.cloud_armor_rate_limit_threshold} requests per minute per IP"

    rate_limit_options {
      conform_action = "allow"
      exceed_action  = "deny(429)"
      rate_limit_threshold {
        count        = var.cloud_armor_rate_limit_threshold
        interval_sec = 60
      }
      enforce_on_key = "IP"
    }
  }

  adaptive_protection_config {
    layer_7_ddos_defense_config {
      enable = true
    }
  }
}

# Serverless NEG for Cloud Run
resource "google_compute_region_network_endpoint_group" "main" {
  count = var.enable_cloud_armor ? 1 : 0

  name                  = "${var.service_name}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region

  cloud_run {
    service = google_cloud_run_service.main.name
  }
}

# Backend service with Cloud Armor policy attached
resource "google_compute_backend_service" "main" {
  count = var.enable_cloud_armor ? 1 : 0

  name        = "${var.service_name}-backend"
  protocol    = "HTTP"
  port_name   = "http"

  backend {
    group = google_compute_region_network_endpoint_group.main[0].id
  }

  security_policy = google_compute_security_policy.main[0].id

  log_config {
    enable      = true
    sample_rate = 1.0
  }
}

# URL map
resource "google_compute_url_map" "main" {
  count = var.enable_cloud_armor ? 1 : 0

  name            = "${var.service_name}-url-map"
  default_service = google_compute_backend_service.main[0].id
}

# Managed SSL certificate
resource "google_compute_managed_ssl_certificate" "main" {
  count = var.enable_cloud_armor ? 1 : 0

  name = "${var.service_name}-ssl-cert"

  managed {
    domains = [var.domain_name]
  }

  lifecycle {
    precondition {
      condition     = var.domain_name != ""
      error_message = "domain_name must be set when enable_cloud_armor is true (an SSL certificate requires a domain)."
    }
  }
}

# HTTPS proxy
resource "google_compute_target_https_proxy" "main" {
  count = var.enable_cloud_armor ? 1 : 0

  name             = "${var.service_name}-https-proxy"
  url_map          = google_compute_url_map.main[0].id
  ssl_certificates = [google_compute_managed_ssl_certificate.main[0].id]
}

# Global static IP address
resource "google_compute_global_address" "main" {
  count = var.enable_cloud_armor ? 1 : 0

  name = "${var.service_name}-lb-ip"
}

# Global forwarding rule (port 443)
resource "google_compute_global_forwarding_rule" "https" {
  count = var.enable_cloud_armor ? 1 : 0

  name       = "${var.service_name}-https-rule"
  target     = google_compute_target_https_proxy.main[0].id
  port_range = "443"
  ip_address = google_compute_global_address.main[0].address
}


