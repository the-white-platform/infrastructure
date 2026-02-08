.PHONY: help setup init-prod plan-prod apply-prod destroy-prod fmt validate clean

# Default target
help:
	@echo "The White Platform - Infrastructure Management"
	@echo ""
	@echo "Setup Commands:"
	@echo "  make setup              - Initial GCP setup (run once)"
	@echo "  make init-prod          - Initialize prod environment"
	@echo ""
	@echo "Deployment Commands:"
	@echo "  make plan-prod          - Plan prod deployment"
	@echo "  make apply-prod         - Apply prod deployment"
	@echo ""
	@echo "Utility Commands:"
	@echo "  make fmt                - Format Terraform files"
	@echo "  make validate           - Validate Terraform configuration"
	@echo "  make clean              - Clean temporary files"
	@echo ""
	@echo "Destruction Commands:"
	@echo "  make destroy-prod       - Destroy prod environment (use with caution!)"

# Setup
setup:
	@bash scripts/setup.sh

# Initialize environments
init-prod:
	@cd terraform/environments/prod && bash setup-env.sh && terraform init

# Plan deployments
plan-prod:
	@cd terraform/environments/prod && terraform plan

# Apply deployments
apply-prod:
	@bash scripts/deploy.sh prod

# Destroy environments
destroy-prod:
	@bash scripts/destroy.sh prod

# Utility commands
fmt:
	@cd terraform && terraform fmt -recursive

validate:
	@cd terraform/environments/prod && terraform validate

clean:
	@find terraform -name "*.tfplan" -delete
	@find terraform -name "tfplan" -delete
	@echo "Cleaned temporary files"

# Quick deploy shortcuts
prod: apply-prod
