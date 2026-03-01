# Budget alert for Vertex AI spend
resource "google_monitoring_notification_channel" "budget_email" {
  count        = var.budget_alert_email != "" ? 1 : 0
  project      = var.project_id
  display_name = "${var.service_name}-budget-alert-email"
  type         = "email"

  labels = {
    email_address = var.budget_alert_email
  }
}

resource "google_billing_budget" "vertex_ai" {
  count           = var.budget_alert_email != "" ? 1 : 0
  billing_account = var.billing_account_id
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
    monitoring_notification_channels = [
      google_monitoring_notification_channel.budget_email[0].id
    ]
    disable_default_iam_recipients = false
  }
}

