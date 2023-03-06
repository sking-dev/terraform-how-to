# How to Set Up a CI/CD Pipeline for PaaS Deployments Using Azure DevOps

WIP (2023-03-06)

----

## Objective

Pending.

----

## Overview

OK...  So...  You've got a pretty decent CI/CD pipeline in place to support your GitOps workflow for IaaS deployments.

The time has come to set up an equivalent pipeline for PaaS deployments (cue dramatic music..!)

You realise that the important difference here is that there's application code to deploy, not just Azure resources.

Also, there will be a number of environments to deploy to, not just a default Production subscription.

----

## Prerequisites

There are a few considerations - AKA "known unknowns" - that it would be helpful to pin down in advance.

TODO: Apply a structure to the draft list below.

- How to structure the Git repository?
  - Your repo for IaaS is structured by Azure service
    - This doesn't seem appropriate here, as PaaS services will (presumably) be separated / distinguished by function / purpose
      - Should it be a flat monolithic repo?
        - Or separate repos?
          - What would the scope of this separation be?
            - Where should the IaC go?
            - Where should the application code go?
- Which branching strategy to use?
- What environments are required?
- How to structure the IaC?
  - Terraform modules
- How to structure the application code
  - Could do with a (very!) simple .NET application to test with
- Will there be a limited set of common build specifications?
  - Or a (very) wide variety?
- Will the apps be deployed / maintained concurrently on a regular basis?
  - Or separately and intermittently?
- Will all the applications have the same lifecycle?
- How many environments will be required?
  - Will any Non-Production environments be required 24x7?
- Which tests should be incorporated into the pipeline?
  - Linting / security / unit / integration / other?
- How should approvals be coordinated for Pull Requests and gates?
  - Where should the gates be placed?
  - How many reviewers?
    - Who should review?
- How can we communicate pipeline activity to any interested parties?
  - Dashboards / notifications / change log / other?

NOTE: There may well be some "unknown unknowns" to factor in..!

----

## Method

Pending.

----

## Acknowledgments

Pending.
