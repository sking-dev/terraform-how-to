# ACME POC Starter for Ten

## Objective

As an IaC engineer, I want to run a pipeline that deploys Terraform code to generate SSL certificates from an ACME Certificate Authority and store them in an Azure Key Vault.

## Overview

Pending.

## Caveats

TBC.

## Challenges

TBC.

## What to Do

Pending.

### Terraform Code

See `/terraform` directory.

### Pipeline Code

See the `/pipelines` directory for the initial YAML pipeline files.

See the `/pipelines-v2` directory for the updated versions.

## Acknowledgements

Useful sources of information that may not be credited elsewhere in this document.

### Primary Sources

- <https://letsencrypt.org/>
- <https://registry.terraform.io/providers/vancluever/acme/latest/docs>
- <https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate>
  - Look for equivalent Azure documentation...
- <https://github.com/vancluever/terraform-provider-acme>

### Secondary Sources

- <https://itnext.io/lets-encrypt-certs-with-terraform-f870def3ce6d>
  - For AWS but may have some useful overlap with Azure
- <https://blog.xmi.fr/posts/tls-terraform-azure-lets-encrypt/>
  - Useful but ends at certificate generation (need to store the generated certificate somewhere...)
- <https://techblog.buzyka.de/2021/02/make-lets-encrypt-certificates-love.html>
  - Not directly useful / relevant as uses automation runbook to automate renewal
    - I want to use a pipeline...
