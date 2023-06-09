# Common Web Platform Terraform Library

## Build Status
| [![Account Infrastructure](https://github.com/ProjectAussie/common-web-platform/actions/workflows/account-deploy.yaml/badge.svg?branch=main)](https://github.com/ProjectAussie/common-web-platform/actions/workflows/account-deploy.yaml) | [![Environment infrastructure](https://github.com/ProjectAussie/common-web-platform/actions/workflows/environment-deploy.yaml/badge.svg?branch=main)](https://github.com/ProjectAussie/common-web-platform/actions/workflows/environment-deploy.yaml) |
| - | - |

## Overview

This repo contains terraform configuration for shared infrastructure used by DTFEE. The repo is divided into two categories, account and environment. Both follow similar patterns. 

### Automation

This repository uses Github Actions and terraform. [Github runners are managed in a separate respository](https://github.com/ProjectAussie/github-runners) and are a requirement to execute terraform within AWS.

Terraform plan is executed and summarized as a part of any commit where changes are detected to terraform.

Terraform apply is automatically ran when changes are merged to master. This happens sequentially and workflows will not execute if any job step fails.

### Organization

This project is organized in a way that makes all terraform configuration reusable. The same basic configuration is applied to all environments. Every environment has a basic requriement of `backend.tfvars`, representing S3 remote state configuration, and `terraform.tfvars`, representing variables that are required and may change between environments.

```bash
account/
├─ nonprod/
│  ├─ backend.tfvars
│  ├─ terraform.tfvars
├─ prod/
│  ├─ backend.tfvars
│  ├─ terraform.tfvars
├─ account-wide.tf
├─ providers.tf
├─ data.tf
environments/
├─ test/
│  ├─ backend.tfvars
│  ├─ terraform.tfvars
├─ cert/
│  ├─ backend.tfvars
│  ├─ terraform.tfvars
├─ data.tf
├─ providers.tf
├─ environment-specific.tf
```

### Account Infrastructure

Account infrastructure includes resources which only need to be created and consumed across the entire account by multiple environments. This can include resources like S3 buckets and account limit configuration.

#### Deployments

| Environment | Account | Region
| - | - | - |
| Nonprod | awsdtfeenp | us-east-1
| Nonprod-DR | awsdtfeenp | us-east-2
| Prod | awsdtfee | us-east-1
| Prod-DR | awsdtfee | us-east-2

### Environment Infrastructure

Environment specific infrastructure that is not shared across the account is also supported by this library. This includes resources that are deployed in each environment, like RDS and Route 53. 

#### Deployments

| Environment | Account | Region
| - | - | - |
| Test | awsdtfeenp | us-east-1
| Cert | awsdtfeenp | us-east-1
| Cert-DR | awsdtfeenp | us-east-2
| UAT | awsdtfee | us-east-1
| Prod | awsdtfee | us-east-1
| Prod-DR | awsdtfee | us-east-2

## Working Locally

This repository allows for branch based development practices and will automatically plan against changes on commit. If you need to work locally, using similar patterns, you can debug issues before pushing your changes.

### Initialization

While in the working directory for `account` or `environments`, simply specify the backend state you wish to initialize against, for example, `nonprod`:

`terraform init -backend-config=nonprod/backend.tfvars`

### Plan

After initializing, similar to above, in order to plan against a specific environment you will need to call the tfvars used for that environment when executing a plan. For example, `cert`:

`terraform plan -var-file=cert/terraform.tfvars`

### Apply

:warning: This repository was created with automation in mind and locally applying terraform is not supported :warning: