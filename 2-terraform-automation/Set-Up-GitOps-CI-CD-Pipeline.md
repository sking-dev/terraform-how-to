# How to Set Up a GitOps CI/CD Pipeline in Azure DevOps

WIP (2022-01-27)

## Objective

As an IaC engineer, I'd like to set up a CI/CD pipeline to support a GitOps workflow for IaC deployments using Terraform.

## Overview

I'm looking to replicate and then improve on the CI/CD pipeline design proposed by a third party service provider for a current cloud migration project.

This CI/CD pipeline is part of a GitOps approach to IaC deployments using Terraform.

We have a POC configured using the Classic Editor in Azure Pipelines (Azure DevOps)

Here's a summary of how the design currently breaks down into pipeline stages / tasks.

- PR to merge code changes to master branch
  - Validation
    - Build Pipeline 1
      - Install Terraform
      - Run `terraform init`
      - Run `terraform validate`
      - Run `terraform plan` (no file output required as not building from this run)
- PR approved
  - Merge to master branch
    - CI
      - Build Pipeline 2
      - Install Terraform
      - Run `terraform init`
      - Run `terraform validate`
      - Run `terraform plan`
      - Produce artifact (file archive that includes Terraform plan file)
      - Publish artifact
    - CD
      - Release Pipeline 1
      - Get published artifact
      - CD trigger (Y/N)
      - PR trigger (Y/N)
      - Pre-deployment triggers
      - Pre-deployment approvals (Y/N)
      - Extract files from archive (artifact)
      - Install Terraform
      - Run `terraform init`
      - Run `terraform apply`

## What to Do

### Create Service Principal in Azure AD

Make sure it gets the Contributor role.

TODO: Add the command here and check it has the necessary parameters.

```json
{
"appId": "...",
"displayName": "sking-dev-sandbox-pipeline",
"password": "...",
"tenant": "..."
}
```

### Add Secrets to Azure Key Vault

Key Vault instance is assumed to be pre-existing.

- sandbox-spn-client-id
- sandbox-spn-secret
- sandbox-spn-tenant-id
- sandbox-tfstate-key1

### Configure Variables in Terraform

Pending.

### Configure Provider in Terraform

Pending.

### Create Variable Group in Azure DevOps Project

This should be linked to the Azure Key Vault (see above) so it can reference the secrets therein.

### Link Variable Group to Build Pipeline

Pending.

### Configure Build Pipeline Task Variables

```bash
terraform plan -input=false -out=tfplan -var="spn-client-id=$(sandbox-spn-client-id)" -var="spn-client-secret=$(sandbox-spn-secret)" -var="spn-tenant-id=$(sandbox-spn-tenant-id)" -var="tfstate-key1=$(sandbox-tfstate-key1)" -var-file="/home/vsts/work/1/s/terraform/terraform.tfvars"
```

### Configure Build Pipeline Tasks

Pending.

### Continuous Integration Trigger

- Branch filter
  - master
- Path filter
  - /terraform/sandbox

### Continuous Deployment Trigger

Run the release pipeline automatically whenever a new build artifact is produced.

### Pre-deployment Conditions

Pending.

----

## Refactor to Multi-stage YAML Pipeline

Pending.

### Improvements to YAML Pipeline

In v2 of multi-stage pipeline, incorporate the following enhancements.

- Streamline Terraform build archive
  - Pipeline cache versus file archive (see below)
- Adopt modular design
  - Use pipeline templates
    - /pipelines
    - /pipelines/templates
- Naming conventions
  - Better readability for UI interaction

### Pipeline Caching

Pending.

Check out the following links.

- <https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/cache?view=azure-devops>
- <https://docs.microsoft.com/en-us/azure/devops/pipelines/release/caching?view=azure-devops>
- <https://itnext.io/infrastructure-as-code-iac-with-terraform-azure-devops-f8cd022a3341>
