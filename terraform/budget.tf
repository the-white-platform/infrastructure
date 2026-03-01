# Budget alert for Vertex AI spend
resource "google_billing_budget" "vertex_ai" {
  count           = var.budget_alert_email != "" ? 1 : 0
  billing_account = "015F7D-99EE6C-0A30FB"
  display_name    = "${var.service_name}-vertex-ai-budget"

  budget_filter {
    projects = ["projects/${var.project_id}"]
    services = ["services/aiplatform.googleapis.com"]
  }

  amount {
    specified_amount {
      currency_code = "USD"
      units         = tostring(var.vto_budget_amount)
    }
  }

  threshold_rules {
    threshold_percent = 0.5
  }
  threshold_rules {
    threshold_percent = 0.9
  }
  threshold_rules {
    threshold_percent = 1.0
  }

  all_updates_rule {
    monitoring_notification_channels = []
    disable_default_iam_recipients   = false
  }
}

