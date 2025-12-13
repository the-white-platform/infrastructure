#!/bin/bash

# Setup script for staging environment
set -e

echo "Setting up staging environment..."

# Create symbolic links to main Terraform files
ln -sf ../../main.tf main.tf
ln -sf ../../variables.tf variables.tf
ln -sf ../../outputs.tf outputs.tf
ln -sf ../../versions.tf versions.tf

# Copy example tfvars if terraform.tfvars doesn't exist
if [ ! -f terraform.tfvars ]; then
  echo "Creating terraform.tfvars from example..."
  cp terraform.tfvars.example terraform.tfvars
  echo "⚠️  Please edit terraform.tfvars with your actual values!"
fi

echo "✅ Staging environment setup complete!"
echo "Next steps:"
echo "1. Edit terraform.tfvars with your configuration"
echo "2. Run: terraform init"
echo "3. Run: terraform plan"
echo "4. Run: terraform apply"
