# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
### [0.1.7](https://github.com/the-white-platform/infrastructure/compare/v0.1.6...v0.1.7) (2025-12-16)


### Bug Fixes

* move cross-project IAM grant to dev environment ([f2a12a1](https://github.com/the-white-platform/infrastructure/commit/f2a12a1c1745e7fa56484af0241d6be8943e6e19))

### [0.1.6](https://github.com/the-white-platform/infrastructure/compare/v0.1.5...v0.1.6) (2025-12-16)


### Bug Fixes

* only run prod terraform on tag creation to avoid lock conflicts ([594eaf8](https://github.com/the-white-platform/infrastructure/commit/594eaf8aa82b7107f6ddcd6aad89ae3be466de58))

### [0.1.5](https://github.com/the-white-platform/infrastructure/compare/v0.1.4...v0.1.5) (2025-12-16)

### [0.1.4](https://github.com/the-white-platform/infrastructure/compare/v0.1.3...v0.1.4) (2025-12-16)


### Bug Fixes

* add create-release workflow and fix tag push to trigger other workflows ([00388d4](https://github.com/the-white-platform/infrastructure/commit/00388d4982347059a0fa43aa8f479b78dfc0ac94))

### [0.1.3](https://github.com/the-white-platform/infrastructure/compare/v0.1.2...v0.1.3) (2025-12-16)


### Code Refactoring

* restructure workflows for proper release flow ([f426a7d](https://github.com/the-white-platform/infrastructure/commit/f426a7df2ddd160921dfd0123f9e5cd6006e110e))

### [0.1.2](https://github.com/the-white-platform/infrastructure/compare/v0.1.1...v0.1.2) (2025-12-16)


### Bug Fixes

* check commit message from git instead of event payload ([7fd3668](https://github.com/the-white-platform/infrastructure/commit/7fd36681531f55f637f395372153910c26abb5ba))
* handle both commit message formats for release commits ([53273cc](https://github.com/the-white-platform/infrastructure/commit/53273cc025df68938b9a0006beeb9e20d521a0e0))

### [0.1.1](https://github.com/the-white-platform/infrastructure/compare/v0.1.0...v0.1.1) (2025-12-16)


### Bug Fixes

* remove paths filter from terraform-dev to allow release commits to trigger ([9686a7d](https://github.com/the-white-platform/infrastructure/commit/9686a7d97fd018e5de879d0f8f6fca926c711cae))

## 0.1.0 (2025-12-16)


### Features

* add Artifact Registry and Secret Manager permissions for Cloud Build ([0863ecf](https://github.com/the-white-platform/infrastructure/commit/0863ecf2223486e1c57ba942e8206f4766c5b570))
* add automatic changelog generation and version bumping ([d7a36f3](https://github.com/the-white-platform/infrastructure/commit/d7a36f31900fcaf78ad30c1df5f3c05a221c5ea8))
* add bootstrap module and configure cloud build credentials ([caaae9e](https://github.com/the-white-platform/infrastructure/commit/caaae9e48c194e06c612bfe8941a54a5781ad88c))
* add Certificate Manager API for SSL certificate management ([e1f57b2](https://github.com/the-white-platform/infrastructure/commit/e1f57b27befb141135cbbd5d36aa4c40993577e5))
* add cleanup script for Workload Identity Federation and update setup script for attribute mapping ([f1c6996](https://github.com/the-white-platform/infrastructure/commit/f1c6996d341d5baadd9fd128e36f25563aee127d))
* add concurrency to cancel previous GitHub Actions runs ([6a13420](https://github.com/the-white-platform/infrastructure/commit/6a13420d17a593909bb6542a1f9675d0bcfe1c47))
* add concurrency to release workflow ([3a3c791](https://github.com/the-white-platform/infrastructure/commit/3a3c791c852799d94af154d15829ad529bc2b7d8))
* add cross-project IAM permissions for image promotion ([7dceb93](https://github.com/the-white-platform/infrastructure/commit/7dceb93773e793696c68701d3b8cc82b0c27d66d))
* add managed cloud sql instance and auto-inject connection secret ([ccdf074](https://github.com/the-white-platform/infrastructure/commit/ccdf0748d2b2ffd9c0b27f517e3d4a9afbe97301))
* add symlinks for sql.tf and triggers.tf, update output message for domain setup ([cdcc913](https://github.com/the-white-platform/infrastructure/commit/cdcc9130e42d143c09378ebccf726f10db8293b5))
* **ci:** add automatic version management for infrastructure ([ad76b28](https://github.com/the-white-platform/infrastructure/commit/ad76b281b7d4fc63ea6dcb60736fc40855aa0de3))
* **ci:** add manual terraform workflows and fix setup script ([573a2de](https://github.com/the-white-platform/infrastructure/commit/573a2de4842dba418827be85b1951a5c585500d2))
* **ci:** add terraform automation workflows for dev and prod ([8554577](https://github.com/the-white-platform/infrastructure/commit/85545773c6906508ec83b25390c9ca343ab8d010))
* config custom domain thewhite.cool for prod ([21fce6a](https://github.com/the-white-platform/infrastructure/commit/21fce6afcb92bf5cded79a84149373551a77b2c5))
* implement tag-based prod deployment and PR-based dev deployment ([f774d81](https://github.com/the-white-platform/infrastructure/commit/f774d81227d69bf445128acb0e3c607afa6efc3e))
* Introduce Terraform for GCP deployment, monitoring, and a 2-stage bootstrap setup, updating README instructions. ([ee5f358](https://github.com/the-white-platform/infrastructure/commit/ee5f3585e1b8b1ba548833f2b08ed726a0cd5094))
* refactor Terraform state management to use existing bucket and add Cloud Build service account permissions ([36ca2b8](https://github.com/the-white-platform/infrastructure/commit/36ca2b8cc350377759113dd8dba740108e0dae97))
* separate envs ([69dc854](https://github.com/the-white-platform/infrastructure/commit/69dc854dab2b3feefc40813916e67c7cadfba7f5))
* update project configuration for dev and prod environments, including region and state bucket name changes ([cd22ae5](https://github.com/the-white-platform/infrastructure/commit/cd22ae5caee704281559dbc95a2919ebbbb3760c))


### Bug Fixes

* add stale lock cleanup before terraform plan ([736b5ad](https://github.com/the-white-platform/infrastructure/commit/736b5ad586ea1c0b830d2999e05faa5ad97ece58))
* always bump version and update changelog ([18bc571](https://github.com/the-white-platform/infrastructure/commit/18bc5718234f6e2162515f2440c9af98a2dfb2a9))
* combine paths into single array in terraform-prod workflow ([9f4ea76](https://github.com/the-white-platform/infrastructure/commit/9f4ea763e1dc0aa1c84105fb7b4a0cef47b72d7f))
* deployment flow ([d03c289](https://github.com/the-white-platform/infrastructure/commit/d03c2899b980b85006b7f137faeb01a251c5384e))
* disable public access (policy) and fix uptime check host ([333ebc6](https://github.com/the-white-platform/infrastructure/commit/333ebc602f63e9f733487b5f5073e077f0aea933))
* ensure version field exists and improve error handling ([e7faf6d](https://github.com/the-white-platform/infrastructure/commit/e7faf6dffde8c37e1f0988b7879e76ba806f6993))
* improve terraform apply condition to check commit message correctly ([0b3cb07](https://github.com/the-white-platform/infrastructure/commit/0b3cb07c2a7090491862ea8ca1a4e74dee6dc6b1))
* include sql.tf in environment setup symlinks ([f1e9592](https://github.com/the-white-platform/infrastructure/commit/f1e9592effa4f18ace2d31c544f6a9b170932a6d))
* move ingress annotation to service metadata ([170c897](https://github.com/the-white-platform/infrastructure/commit/170c897faee76ec773d2ef66b5d8021eaf3da540))
* pass all required terraform variables explicitly ([8a8efae](https://github.com/the-white-platform/infrastructure/commit/8a8efaea049c52a126844e758aa3bdf4f9a5112c))
* pass environment variable explicitly in terraform plan ([891176a](https://github.com/the-white-platform/infrastructure/commit/891176ab208418aa5719ffaf907d4447c11cc54f))
* pass terraform variables directly instead of using tfvars file ([946aa79](https://github.com/the-white-platform/infrastructure/commit/946aa79197ca04e8f613bc7c6c649af8ca93c5af))
* prevent null version in release commit message ([fa85514](https://github.com/the-white-platform/infrastructure/commit/fa855148bbd1831a177b513d9b459bf0e3a6e0b1))
* prevent release workflow loop ([3559c15](https://github.com/the-white-platform/infrastructure/commit/3559c15279ac185592a9d896e41087842f5a4f2d))
* prod workflow only triggers on tag pushes, not release commits ([5ef459e](https://github.com/the-white-platform/infrastructure/commit/5ef459e5d930dbb8e7955bf5cb6198f5ee3dceaa))
* remove custom ENV variable to avoid Cloud Build substitution error ([5431997](https://github.com/the-white-platform/infrastructure/commit/5431997f7591629b0e5f2039b221dc6f13bb8b61))
* remove terraform.tfvars from gitignore and commit the files ([6d4eb7b](https://github.com/the-white-platform/infrastructure/commit/6d4eb7bfd32d71620acfa1bb6d0c754be9161f9c))
* remove unused _ENVIRONMENT substitution from triggers ([67f9980](https://github.com/the-white-platform/infrastructure/commit/67f9980e3db4ff608e193afebe8877480ab26ecd))
* restructure terraform workflows to match desired flow ([c559426](https://github.com/the-white-platform/infrastructure/commit/c559426b10f3695d3c3d55c9efeae0a0318ebefd))
* restructure terraform workflows to match desired flow ([73b1428](https://github.com/the-white-platform/infrastructure/commit/73b1428828649a7100f89414b73d882bfce989f0))
* **secret:** grant Cloud Build SA access to Secret Manager ([47a763e](https://github.com/the-white-platform/infrastructure/commit/47a763eed803e2de0f495c49c63b7cfcac38bcb9))
* separate push triggers for branches and tags in terraform-prod ([49ef60f](https://github.com/the-white-platform/infrastructure/commit/49ef60f9b94babd6f0fcfa2737b6252a3a46db7c))
* set version to 0.0.1 in package.json ([ded84b1](https://github.com/the-white-platform/infrastructure/commit/ded84b1e7fa84cca64451af39343fe6161b8c5bc))
* simplify stale lock cleanup logic ([c732ae4](https://github.com/the-white-platform/infrastructure/commit/c732ae431c73f0cb7cfaa7162229fd441e49f245))
* update project_id to the-white-dev in all environments ([d7048a0](https://github.com/the-white-platform/infrastructure/commit/d7048a0a0a9286fe3fced6e10dca8750a500d4bc))
* update region to europe-north1 and ensure buckets exist ([b5c9ba8](https://github.com/the-white-platform/infrastructure/commit/b5c9ba82dab1e67c0e77c8507b8b0791367b5cc0))
* upgrade terraform version to 1.9.0 to satisfy constraints ([ad8750d](https://github.com/the-white-platform/infrastructure/commit/ad8750d3ea974bb3fbf62d3eae28a6645ff33cdf))
* use correct path for terraform.tfvars and clean up workflows ([cac770e](https://github.com/the-white-platform/infrastructure/commit/cac770e8a446139059d57f1eb67060f81761d060))
* use hello-world image for initial infrastructure bootstrap ([e0395f0](https://github.com/the-white-platform/infrastructure/commit/e0395f0d55b5f788e3b629f688d60e0442315d43))
* use PROJECT_ID instead of BRANCH_NAME for environment detection in Cloud Build ([92ab868](https://github.com/the-white-platform/infrastructure/commit/92ab8688978f776da39f8f9bd5b510cf60ddd13f))

## [0.0.1] - 2025-12-16

### Added

- Initial infrastructure setup with Terraform
- Cloud Run service configuration for dev and prod environments
- Artifact Registry for Docker images
- Secret Manager integration
- GitHub Actions workflows for Terraform apply
- Automatic changelog generation and version bumping
- Workload Identity Federation for secure GCP access
- Cross-project IAM permissions for image promotion

[Unreleased]: https://github.com/the-white-platform/infrastructure/compare/v0.0.1...HEAD
[0.0.1]: https://github.com/the-white-platform/infrastructure/releases/tag/v0.0.1

