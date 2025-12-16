# Infrastructure as Code (IaC) for The White Platform

This directory contains Terraform configurations for deploying and managing The White Platform on Google Cloud Platform (GCP).

## 📁 Directory Structure

```
.
├── README.md                 # This file
├── cloudbuild.yaml          # CI/CD configuration
├── Makefile                 # Shortcuts for common tasks
├── terraform/
│   ├── main.tf              # Main Terraform configuration
│   ├── variables.tf         # Input variables
│   ├── outputs.tf           # Output values
│   ├── versions.tf          # Provider versions
│   ├── backend.tf           # Remote state configuration
│   ├── modules/
│   │   ├── cloud-run/       # Cloud Run service module
│   │   ├── secrets/         # Secret Manager module
│   │   ├── networking/      # VPC and networking module
│   │   └── monitoring/      # Monitoring and alerting module
│   └── environments/
│       ├── dev/             # Development environment
│       ├── staging/         # Staging environment
│       └── prod/            # Production environment
└── scripts/
    ├── setup.sh             # Initial setup script
    ├── deploy.sh            # Deployment script
    └── destroy.sh           # Cleanup script
```

## 🚀 Prerequisites

1. **Google Cloud SDK**: Install and configure `gcloud` CLI

   ```bash
   gcloud auth login
   gcloud config set project YOUR_PROJECT_ID
   ```

2. **Terraform**: Install Terraform (v1.5.0 or later)

   ```bash
   brew install terraform
   ```

3. **GCP Project**: Create a GCP project and enable required APIs

   - Cloud Run API
   - Cloud Build API
   - Secret Manager API
   - Container Registry API
   - Cloud SQL Admin API (if using Cloud SQL)

4. **Service Account**: Create a service account with appropriate permissions

   ```bash
   gcloud iam service-accounts create terraform-sa \
     --display-name="Terraform Service Account"

   gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
     --member="serviceAccount:terraform-sa@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
     --role="roles/editor"
   ```

## 🔧 Setup (The "Bootstrap" Way)

We use a 2-stage process:

1. **Bootstrap**: Sets up the foundations (APIs, State Bucket, Service Account)
2. **Main**: Sets up the application infrastructure

### 1. Run Bootstrap

This step is run **once per project** using your personal admin credentials.

```bash
# 1. Login with your personal account
gcloud auth login
gcloud config set project YOUR_PROJECT_ID

# 2. Configure Bootstrap
cd terraform/bootstrap
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your project_id

# 3. Apply
terraform init
terraform apply
```

This will output your new **State Bucket Name** and **Service Account Email**.

### 2. Configure Main Infrastructure

Now you use the resources created above to manage the rest.

1. **Update Backend Config**:
   Edit `terraform/environments/dev/backend.tf` (and others) to use the new bucket name from the bootstrap output.

2. **Configure Environment**:

   ```bash
   cd terraform/environments/dev
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with:
   # - project_id = "YOUR_PROJECT_ID"
   # - Any other settings
   ```

3. **Deploy Application Infrastructure**:
   ```bash
   bash setup-env.sh
   terraform init
   terraform apply
   ```

## 🌍 Environments

### Development

- **Region**: us-central1
- **Min Instances**: 0
- **Max Instances**: 3
- **Memory**: 1Gi
- **CPU**: 1

### Staging

- **Region**: us-central1
- **Min Instances**: 1
- **Max Instances**: 5
- **Memory**: 2Gi
- **CPU**: 2

### Production

- **Region**: us-central1 (primary), us-east1 (backup)
- **Min Instances**: 2
- **Max Instances**: 10
- **Memory**: 2Gi
- **CPU**: 2

## 📝 Common Commands

### Deploy to Development

```bash
cd terraform/environments/dev
terraform apply
```

### Deploy to Production

```bash
cd terraform/environments/prod
terraform apply
```

### View Outputs

```bash
terraform output
```

### Destroy Infrastructure

```bash
terraform destroy
```

## 🔐 Secrets Management

Secrets are managed using Google Secret Manager. To add a new secret:

```bash
echo -n "your-secret-value" | gcloud secrets create SECRET_NAME \
  --data-file=- \
  --replication-policy="automatic"
```

Required secrets:

- `DATABASE_URI`: PostgreSQL connection string
- `PAYLOAD_SECRET`: JWT encryption key

## 🔄 CI/CD Integration

The infrastructure integrates with Cloud Build for automated deployments.

### Setting up the Trigger

1. Go to **Cloud Build** > **Triggers**
2. Click **Create Trigger**
3. **Name**: `infrastructure-deploy`
4. **Event**: push to a branch
5. **Source**: Select your repository (the-white-infrastructure)
6. **Branch**: `^main$|^develop$|^staging$` (for deployments) or `.*` (to also plan on feature branches)
7. **Build Configuration**:
   - Type: Cloud Build configuration file (yaml or json)
   - Location: `cloudbuild.yaml`
8. **Included files filter**: (Optional, generic) `**`

### Workflow

1. **Feature Branches**: Runs `terraform plan` to validate changes without applying.
2. **Develop Branch**: Deploys to the **Dev** environment.
3. **Staging Branch**: Deploys to the **Staging** environment.
4. **Main Branch**: Deploys to the **Production** environment.

#### Skip CI/CD

To skip CI/CD workflows (e.g., when updating documentation), include one of these in your commit message:
- `[skip ci]`
- `[ci skip]`
- `[skip actions]`
- `[actions skip]`

Example:
```bash
git commit -m "docs: update README [skip ci]"
```

## 📊 Monitoring

Access monitoring dashboards:

- **Cloud Run Metrics**: GCP Console → Cloud Run → fashion-web
- **Logs**: GCP Console → Logging → Logs Explorer
- **Alerts**: GCP Console → Monitoring → Alerting

## 🛠️ Troubleshooting

### State Lock Issues

```bash
terraform force-unlock LOCK_ID
```

### Import Existing Resources

```bash
terraform import google_cloud_run_service.main projects/PROJECT_ID/locations/REGION/services/SERVICE_NAME
```

### Refresh State

```bash
terraform refresh
```

## 📚 Additional Resources

- [Terraform GCP Provider Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Cloud Run Documentation](https://cloud.google.com/run/docs)
- [Secret Manager Documentation](https://cloud.google.com/secret-manager/docs)

## 🤝 Contributing

When making infrastructure changes:

1. Create a new branch
2. Make changes in the appropriate environment
3. Run `terraform plan` and review changes
4. Create a pull request
5. After approval, apply changes

## 📄 License

This infrastructure configuration is part of The White Platform project.
# Trigger release
