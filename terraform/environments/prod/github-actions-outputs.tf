# Outputs for GitHub Actions WIF configuration (PROD)

output "github_actions_wif_provider" {
  description = "Full WIF provider resource name for GitHub Actions"
  value       = local.wif_provider_name
}

output "github_actions_service_account" {
  description = "Service account email for GitHub Actions deployments"
  value       = google_service_account.github_actions_deployer.email
}

output "github_actions_wif_setup_instructions" {
  description = "Instructions for setting up GitHub secrets"
  value = <<-EOT
    Add these secrets to GitHub (organization-level recommended):
    
    Organization: https://github.com/organizations/the-white-platform/settings/secrets/actions
    Or Repository: https://github.com/the-white-platform/fashion-web/settings/secrets/actions
    
    WIF_PROVIDER_PROD = ${local.wif_provider_name}
    WIF_SERVICE_ACCOUNT_PROD = ${google_service_account.github_actions_deployer.email}
    
    For organization secrets: Select "Selected repositories" and choose fashion-web
  EOT
}

