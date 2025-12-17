# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
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
