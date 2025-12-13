.PHONY: help setup init-dev init-staging init-prod plan-dev plan-staging plan-prod apply-dev apply-staging apply-prod destroy-dev destroy-staging destroy-prod fmt validate clean

# Default target
help:
	@echo "The White Platform - Infrastructure Management"
	@echo ""
	@echo "Setup Commands:"
	@echo "  make setup              - Initial GCP setup (run once)"
	@echo "  make init-dev           - Initialize dev environment"
	@echo "  make init-staging       - Initialize staging environment"
	@echo "  make init-prod          - Initialize prod environment"
	@echo ""
	@echo "Deployment Commands:"
	@echo "  make plan-dev           - Plan dev deployment"
	@echo "  make plan-staging       - Plan staging deployment"
	@echo "  make plan-prod          - Plan prod deployment"
	@echo "  make apply-dev          - Apply dev deployment"
	@echo "  make apply-staging      - Apply staging deployment"
	@echo "  make apply-prod         - Apply prod deployment"
	@echo ""
	@echo "Utility Commands:"
	@echo "  make fmt                - Format Terraform files"
	@echo "  make validate           - Validate Terraform configuration"
	@echo "  make clean              - Clean temporary files"
	@echo ""
	@echo "Destruction Commands:"
	@echo "  make destroy-dev        - Destroy dev environment"
	@echo "  make destroy-staging    - Destroy staging environment"
	@echo "  make destroy-prod       - Destroy prod environment (use with caution!)"

# Setup
setup:
	@bash scripts/setup.sh

# Initialize environments
init-dev:
	@cd terraform/environments/dev && bash setup-env.sh && terraform init

init-staging:
	@cd terraform/environments/staging && bash setup-env.sh && terraform init

init-prod:
	@cd terraform/environments/prod && bash setup-env.sh && terraform init

# Plan deployments
plan-dev:
	@cd terraform/environments/dev && terraform plan

plan-staging:
	@cd terraform/environments/staging && terraform plan

plan-prod:
	@cd terraform/environments/prod && terraform plan

# Apply deployments
apply-dev:
	@bash scripts/deploy.sh dev

apply-staging:
	@bash scripts/deploy.sh staging

apply-prod:
	@bash scripts/deploy.sh prod

# Destroy environments
destroy-dev:
	@bash scripts/destroy.sh dev

destroy-staging:
	@bash scripts/destroy.sh staging

destroy-prod:
	@bash scripts/destroy.sh prod

# Utility commands
fmt:
	@cd terraform && terraform fmt -recursive

validate:
	@cd terraform/environments/dev && terraform validate
	@cd terraform/environments/staging && terraform validate
	@cd terraform/environments/prod && terraform validate

clean:
	@find terraform -name "*.tfplan" -delete
	@find terraform -name "tfplan" -delete
	@echo "Cleaned temporary files"

# Quick deploy shortcuts
dev: apply-dev
staging: apply-staging
prod: apply-prod
