# Pipelines Directory

This directory contains an example of the template(d) approach to configuring a multi-stage YAML pipeline for Terraform deployments.

The pipeline files within this directory effectively call their configuration from the template files stored in the `/pipelines/templates` subdirectory.

To create a new pipeline file, copy the "sandbox-" example files, edit them as per the new deployment requirement, and then give them meaningful names.

E.g. if the new pipeline is intended to deploy virtual machines, two new pipeline files should be created as follows.

```bash
/pipelines/azure-pipelines.vm-validate.yaml

/pipelines/azure-pipelines.vm-deploy.yaml
```

The modular design means that only minimal edits should be required.

These are signposted via inline comments in each YAML file.

NOTE: The template files in the `pipelines/templates` subdirectory should **not** need to be edited unless a global change to pipeline configuration is required e.g. a new stage is to be added to _all_ the pipelines, or an existing stage needs to be updated for _all_ the pipelines.
