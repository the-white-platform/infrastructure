# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
### [0.0.2](https://github.com/the-white-platform/infrastructure/compare/v0.0.1...v0.0.2) (2025-12-16)


### Bug Fixes

* ensure GitHub releases are published (not draft) ([b8227df](https://github.com/the-white-platform/infrastructure/commit/b8227df2765f6393edc8cccf518d0ac6f7e9bcf0))

## [0.0.1] - 2025-12-16

### Added

- Initial infrastructure setup with Terraform
- Cloud Run service configuration for dev and prod environments
- Artifact Registry for Docker images
- Secret Manager integration
- GitHub Actions workflows for Terraform automation
- Automated changelog generation and version bumping
- Workload Identity Federation for secure GCP access
- Cross-project IAM permissions for image promotion
- Terraform workflows for dev and prod with proper triggers
- Release workflow for automated versioning
