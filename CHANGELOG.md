# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
### [0.5.4](https://github.com/the-white-platform/infrastructure/compare/v0.5.3...v0.5.4) (2026-03-28)


### Bug Fixes

* reduce GCP costs ~80% — disable LB/Armor, scale to zero, downsize ([b48a300](https://github.com/the-white-platform/infrastructure/commit/b48a300258ab87f24393ed98a3b1dcf3103f776c))

### [0.5.3](https://github.com/the-white-platform/infrastructure/compare/v0.5.2...v0.5.3) (2026-03-04)


### Bug Fixes

* skip Cloud Run domain mapping when Cloud Armor LB is enabled ([43602fb](https://github.com/the-white-platform/infrastructure/commit/43602fb3bd253d3a0d3749e1211d490d51cba1df))

### [0.5.2](https://github.com/the-white-platform/infrastructure/compare/v0.5.1...v0.5.2) (2026-03-01)


### Bug Fixes

* grant compute.securityAdmin and compute.networkAdmin to GitHub Actions deployer SA ([c233ee3](https://github.com/the-white-platform/infrastructure/commit/c233ee377b9400cf3f8e49e595a7827509de4782))

### [0.5.1](https://github.com/the-white-platform/infrastructure/compare/v0.5.0...v0.5.1) (2026-03-01)


### Bug Fixes

* add armor.tf and budget.tf to prod environment module ([0431aaf](https://github.com/the-white-platform/infrastructure/commit/0431aaf1d3528bf303cc44eb4623f88f99f00c26))

## [0.5.0](https://github.com/the-white-platform/infrastructure/compare/v0.4.0...v0.5.0) (2026-03-01)


### Features

* add GCP configuration variables to production environment ([8149a5f](https://github.com/the-white-platform/infrastructure/commit/8149a5fdb7092a4ed8acb94b22a6b0fc5b212d9d))
* add Vertex AI budget alerts with configurable thresholds ([f20c6e1](https://github.com/the-white-platform/infrastructure/commit/f20c6e1bc4edd4dd980dc54ac4d645873434f2a0))
* **armor:** add precondition validation for domain_name in SSL certific ([4aa4d03](https://github.com/the-white-platform/infrastructure/commit/4aa4d0370e1bc90e0a20b5c3f370b379cb8b5737))
* **budget:** make billing account ID configurable and add email notific ([f2ce856](https://github.com/the-white-platform/infrastructure/commit/f2ce856252ea6d94f6a2178547fae04eb5389fe2))
* enable Vertex AI VTO and Cloud Armor in production environment ([a27d1eb](https://github.com/the-white-platform/infrastructure/commit/a27d1ebe1b198b64d88204bbd006f1bdf414b85d))
* merge vertex-ai-virtual-try-on-iac into main ([b159859](https://github.com/the-white-platform/infrastructure/commit/b1598590616158402e845f6bacb65e92b3c117da))


### Bug Fixes

* **armor:** remove timeout_sec configuration from backend service ([acf3870](https://github.com/the-white-platform/infrastructure/commit/acf38701016466d288683b5b7215102a73d6d1d1))

## [0.4.0](https://github.com/the-white-platform/infrastructure/compare/v0.3.1...v0.4.0) (2026-02-26)


### Features

* add Cloud Armor DDoS protection with global HTTPS load balancer ([d00b94b](https://github.com/the-white-platform/infrastructure/commit/d00b94b0a249f378c63c20df80cee4d6c1f948c8))
* add Vertex AI Virtual Try-On and Cloud Armor support ([b59d82d](https://github.com/the-white-platform/infrastructure/commit/b59d82d9186b0154f591503db7b933d18e395e98))


### Documentation

* add Vertex AI VTO and Cloud Armor configuration examples to terraf ([3939a0c](https://github.com/the-white-platform/infrastructure/commit/3939a0cb08c1392d47342a6065a15b61462315ff))

### [0.3.1](https://github.com/the-white-platform/infrastructure/compare/v0.3.0...v0.3.1) (2026-02-09)


### Bug Fixes

* grant cloudsql.admin role to GitHub Actions deployer SA ([4bcf2ae](https://github.com/the-white-platform/infrastructure/commit/4bcf2aec785efe65199146217668a989e2a5d71c))

## [0.3.0](https://github.com/the-white-platform/infrastructure/compare/v0.2.14...v0.3.0) (2026-02-09)


### Features

* enable Cloud SQL and drop external Neon dependency ([20c1b50](https://github.com/the-white-platform/infrastructure/commit/20c1b50a8cbb10e555ec552667d8290bbd44377f))

### [0.2.14](https://github.com/the-white-platform/infrastructure/compare/v0.2.13...v0.2.14) (2026-02-08)


### CI/CD

* remove WIF import and stale lock workarounds from prod workflow ([017973c](https://github.com/the-white-platform/infrastructure/commit/017973ccf6a05ae35eb5a4de7eb81cbbcb12b280))
* replace hardcoded values with GitHub org variables ([ada9cb5](https://github.com/the-white-platform/infrastructure/commit/ada9cb520b2c83cbb4b96cd28a216704aa179a84))

### [0.2.13](https://github.com/the-white-platform/infrastructure/compare/v0.2.12...v0.2.13) (2026-02-08)


### CI/CD

* remove dev environment and Cloud Build infrastructure ([1180adc](https://github.com/the-white-platform/infrastructure/commit/1180adc493e3acfcf0c4df628965b338caa4f16b))

### [0.2.12](https://github.com/the-white-platform/infrastructure/compare/v0.2.11...v0.2.12) (2025-12-17)


### Bug Fixes

* remove data source for prod service account in dev iam.tf ([df72e1c](https://github.com/the-white-platform/infrastructure/commit/df72e1cdbeb3a8ec51e0ea06c5a06dc37a526472))

### [0.2.11](https://github.com/the-white-platform/infrastructure/compare/v0.2.10...v0.2.11) (2025-12-17)

### [0.2.10](https://github.com/the-white-platform/infrastructure/compare/v0.2.9...v0.2.10) (2025-12-17)


### Bug Fixes

* add lifecycle ignore_changes for pool project field ([8caca0a](https://github.com/the-white-platform/infrastructure/commit/8caca0a03f15bf8a2dbcb38d98761d30877cb074))
* add lifecycle ignore_changes for pool project field in dev ([e7521d9](https://github.com/the-white-platform/infrastructure/commit/e7521d915576fae4a963579454a22b291e84f6db))

### [0.2.9](https://github.com/the-white-platform/infrastructure/compare/v0.2.8...v0.2.9) (2025-12-17)


### Bug Fixes

* add service account self-permission for token creator ([78e9fa0](https://github.com/the-white-platform/infrastructure/commit/78e9fa00e9593578d56e92f17a35b536300bca6d))
* improve pool import logic and add service account self-permission ([50ddd0a](https://github.com/the-white-platform/infrastructure/commit/50ddd0a17324012e64a5b6c73887a3a21e69f3e0))

### [0.2.8](https://github.com/the-white-platform/infrastructure/compare/v0.2.7...v0.2.8) (2025-12-17)


### Bug Fixes

* add roles/iam.serviceAccountTokenCreator for GCS state access ([d9d98fe](https://github.com/the-white-platform/infrastructure/commit/d9d98fe0e825e68fc57c265e684f07af84fe0798))

### [0.2.7](https://github.com/the-white-platform/infrastructure/compare/v0.2.6...v0.2.7) (2025-12-17)


### Bug Fixes

* ignore project field changes in WIF provider lifecycle ([312e4e9](https://github.com/the-white-platform/infrastructure/commit/312e4e94bfb5307955de981f1e75cbe07e6b202b))
* use terraform state list instead of state show for import checks ([3a7b632](https://github.com/the-white-platform/infrastructure/commit/3a7b63292a5806c315f8e4abdf538d464bb68d25))

### [0.2.6](https://github.com/the-white-platform/infrastructure/compare/v0.2.5...v0.2.6) (2025-12-17)


### Bug Fixes

* ensure WIF provider import actually succeeds ([ed6a949](https://github.com/the-white-platform/infrastructure/commit/ed6a949fcfc5b4a700c534eda4602efcc092b896))
* improve WIF provider import error handling ([d5307df](https://github.com/the-white-platform/infrastructure/commit/d5307dff2865d78efcb18146d251ca7d60e0ecb8))
* improve WIF provider import error handling in dev workflow ([395a329](https://github.com/the-white-platform/infrastructure/commit/395a32919064deeeffde3a6b9b3a9b6bdcdc2bfd))

### [0.2.5](https://github.com/the-white-platform/infrastructure/compare/v0.2.4...v0.2.5) (2025-12-17)


### Bug Fixes

* add roles/iam.serviceAccountAdmin for managing service account IAM ([979db51](https://github.com/the-white-platform/infrastructure/commit/979db51013f8cc44c2a419445ab4ed2de7dec364))

### [0.2.4](https://github.com/the-white-platform/infrastructure/compare/v0.2.3...v0.2.4) (2025-12-17)


### Bug Fixes

* revert to roles/iam.workloadIdentityPoolAdmin (project-level role) ([479da0c](https://github.com/the-white-platform/infrastructure/commit/479da0c1c40664f9efcb892cd38364c74f07d3b7))

### [0.2.3](https://github.com/the-white-platform/infrastructure/compare/v0.2.2...v0.2.3) (2025-12-17)


### Bug Fixes

* use roles/iam.admin instead of workloadIdentityPoolAdmin ([200e17e](https://github.com/the-white-platform/infrastructure/commit/200e17e0ae770ad8d507843b1de3ee5ceb250f75))

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
