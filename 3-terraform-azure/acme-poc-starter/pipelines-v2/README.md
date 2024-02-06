# ACME POC Pipelines v2

This directory contains three YAML pipeline files.

- The calling pipeline for ACME deployments has been refactored to support CI/CD (previously it was run manually to facilitate testing)
  - It deploys the Terraform code to four environments (DEV / SIT / UAT / LIV)
    - The deployment to DEV is part of the PR build validation
    - There are approval gates for the other three environments (SIT / UAT / LIV)
      - The code author can approve for SIT and UAT but **not** for LIV

- A scheduled version of the calling pipeline that does **not** support CI/CD
  - This is required to run on a regular basis to check for certificate renewals
  - There is no PR validation or approval gates - if a deployment is required, it's done from the `main` branch

- A triggered pipeline that runs against the (separate) Terraform module for Application Gateway resources
  - Why do this?
    - After the scheduled pipeline runs to check for certificate renewals, we need give the Application Gateway resources a "nudge" to update the certificates they use
    - An alternative approach could be to use an PowerShell script task within the scheduled pipeline to restart the Application Gateway resources but this is neater (imo) when there are a number of AGW resources to manage
    - NOTE: AGW resources are allegedly able to poll Azure Key Vault at regular intervals to update certificates but I haven't seen any evidence of this to date - another thing to return to at a later date..!
