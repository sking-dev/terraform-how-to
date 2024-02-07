# Set Up Pipeline with Runtime Parameters

It can be useful to be able to control what a pipeline does by running it manually and setting the runtime parameters as required.

In this example, there's a single runtime parameter that presents a choice of four options for the deployment environment ("dev" / "sit" / "qau" / "liv")

The pipeline then targets the tasks that it carries out at the chosen environment e.g. it references the appropriate Terraform state file, the appropriate Azure Pipelines library group, and so forth.

This directory contains two calling pipeline YAML files as follows.

- A "validate" pipeline file
  - This is used as part of PR build validation
    - When a PR is created, this pipeline validates and tests the Terraform code
      - It runs 'terraform plan' to check what the changes will be but it **doesn't** output a plan file

- A "deploy" pipeline file
  - This is used when the PR has been completed and the code is merged
    - When 'terraform plan' runs in the "Plan" stage, it **does** produce a plan output file to be used by the "Apply" stage

It also contains a sub-directory for template YAML files.  

These templates are referenced in each calling pipeline file as required.
