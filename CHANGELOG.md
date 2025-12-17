# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
### [0.2.2](https://github.com/the-white-platform/infrastructure/compare/v0.2.1...v0.2.2) (2025-12-17)


### Bug Fixes

* add IAM workload identity pool admin role and manual grant script ([844cb93](https://github.com/the-white-platform/infrastructure/commit/844cb931ca866d14efe0379c5d5d9c0bcc697ce2))

### [0.2.1](https://github.com/the-white-platform/infrastructure/compare/v0.2.0...v0.2.1) (2025-12-17)


### Bug Fixes

* add Terraform permissions to GitHub Actions service accounts ([3ed4331](https://github.com/the-white-platform/infrastructure/commit/3ed4331e5588cc0692759d0dabd26d077ff5c7fd))
* add WIF import step to PR plan job and create_credentials_file to release auth ([0c6c331](https://github.com/the-white-platform/infrastructure/commit/0c6c3312c71d754860d6481abc68c6e8d63d70c4))
* improve WIF import step in dev workflow with better error visibility ([0299739](https://github.com/the-white-platform/infrastructure/commit/0299739aa4c0fec47c4b5dfde3ffd7e91d2f30d0))
* improve WIF import step with better error visibility and state checks ([41811e8](https://github.com/the-white-platform/infrastructure/commit/41811e8d8db02e566a03b161d751e9346cf3c6f9))

## [0.2.0](https://github.com/the-white-platform/infrastructure/compare/v0.1.2...v0.2.0) (2025-12-17)


### Features

* add auto-import step for WIF resources in dev workflow ([1b180d2](https://github.com/the-white-platform/infrastructure/commit/1b180d21aa2391ee9214d9083c7a0b4ff509a43b))
* add WIF resources to Terraform and auto-import if they exist ([1b968ba](https://github.com/the-white-platform/infrastructure/commit/1b968ba6c7fb9d839c162eb2d5d0285dd6166795))

### [0.1.2](https://github.com/the-white-platform/infrastructure/compare/v0.1.1...v0.1.2) (2025-12-17)


### Bug Fixes

* remove empty prod/iam.tf file ([a9aea50](https://github.com/the-white-platform/infrastructure/commit/a9aea50301923767734ad2c146a3e1d963bfa967))

### [0.1.1](https://github.com/the-white-platform/infrastructure/compare/v0.1.0...v0.1.1) (2025-12-17)


### Bug Fixes

* remove unused data source from prod/iam.tf ([82e8922](https://github.com/the-white-platform/infrastructure/commit/82e8922791f4a8d606f841179122ca6808d83cb9))

## [0.1.0](https://github.com/the-white-platform/infrastructure/compare/v0.0.2...v0.1.0) (2025-12-17)


### Features

* add option to skip CI/CD with [skip ci] in commit message ([f6b869d](https://github.com/the-white-platform/infrastructure/commit/f6b869da5b19f7ce1d33cd763e75ee18e383e83d))
* add path filters to reduce workflow triggers ([aef25e4](https://github.com/the-white-platform/infrastructure/commit/aef25e4263bef709cf2d3742733dfc2e29dd5542))


### Bug Fixes

* prevent workflow from running on release commits ([c493946](https://github.com/the-white-platform/infrastructure/commit/c4939460a3b890dd7b6928033ed2c80dbf9142da))

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
