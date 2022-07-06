# Upgrade Provider Version for Terraform Modules

WIP (2022-07-06)

## Objective

As an IaC engineer, I want to upgrade the 'azurerm' provider version used by the Terraform modules in my Production codebase in the safest and most efficient way possible.

NOTE: In this document, the term "module(s)" is used in its truest sense i.e. Terraform code that's designed to be mega DRY (nice!) by gathering resources together so they can be deployed in a (much) more repeatable way.  

It can be confusing because, in the wider Terraform context, "module" can also refer to any working directory that contains a Terraform configuration and acts as the source for Terraform operations e.g. `terraform init`, `terraform plan`, and so forth.

## Background

Let me paint a picture for you (AKA what's the scenario that's prompted me to put fingers to keyboard..!)

I have a root module that calls a number of child modules to deploy different Azure services on a per region basis.

```plaintext
Let's call the root module "network" and the child modules can be "vnet", "app-gateway", and "load-balancer".
```

The Terraform code in each child module is deliberately location-agnostic so that each Azure location - the primary Production location and the secondary DR location - can be kept in sync by default.

I have a requirement to upgrade the 'azurerm' provider across the codebase, but I don't want to upgrade this particular module in one hit.

My preference is to upgrade each child module separately to limit the blast radius e.g. if the upgrade exposes any issues such as deprecated resources or missing required arguments, doing it in "one hit" will impact on the module as a whole so we'll have multiple child modules to troubleshoot before we can resume normal service for the Production codebase plus the associated deployment pipelines.

## What Approach Should I Adopt?

Currently, the recommended (HashiCorp best practice) provider version constraint is only present in the root module.

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # Constrain / pin to a specific version.
      version = "=2.99.0"
    }
  }
}
```

The child modules are effectively inheriting this constraint so, if we update the block above to pin the version to 3.9.0, for example, we'll be forcing all the child modules to use this later version with the attendant risks outlined above.

### So What to Do?

As a first step, I'm going to broaden out the constraint in the root module to specify the **maximum version** of the provider that we want to the root module to allow.

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # Constrain to a maximum version.
      version = ""~> 3.9.0"
    }
  }
}
```

Secondly, I add the original / current constraint into each child module (e.g. within a `provider.tf` file) so that they'll continue to use v2.99.0 until we're ready to perform the upgrade on a per child module basis.

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.99.0"
    }
  }
}
```

### Nice Idea But It Doesn't Work

The above approach did not work as expected.  Boo!

```bash
│ Error: Failed to query available provider packages
│ 
│ Could not retrieve the list of available versions for provider
│ hashicorp/azurerm: no available releases match the given constraints
│ 2.99.0, 3.9.0, ~> 3.9.0
╵
```

In case my logic was faulty, I tried modifying my root module's constraint to specify any version **less than or equal** to v3.9.0.

```hcl
version = "<= 3.9.0"
```

This also failed with the same error which, unfortunately, has the same underlying cause.

### What's That Then?

Upgrading multiple child modules separately / independently is **not supported**, as there can only be one provider version per (overall) module which effectively means that the child modules version can't conflict with the expectation set in the root module.

E.g. if the root module specifies "<=3.9.0" and the three child modules each specify "=2.99.0", there's no problem and v2.99.0 will be downloaded when 'terraform init' is run against the root module.

However, if if the root module specifies "<=3.9.0" and the third child module specifies "=3.9.0" instead of "=2.99.0", the 'terraform init' operation will fail.

```bash
│ Error: Failed to query available provider packages
│
│ Could not retrieve the list of available versions for provider
│ hashicorp/azurerm: no available releases match the given constraints
│ 2.99.0, 3.9.0, <= 3.9.0
```

## Back to the Drawing Board

As I see it, I have two options at this point.

1. Do the upgrade in one hit i.e. the entire 'network' module codebase including child modules.  The safest way to do this will be to test in a non-Production environment or sandbox so that the potential impact on each service / configuration can be assessed.
2. Split the child modules out so that each service has its own root module plus associated configuration.  This will require some planning because it will affect how the Terraform state is handled for these services (Azure resources) both in terms of requiring separate state files for each new root module and outputs / data sources that will allow the newly independent modules to reference each other as required.

Neither option fills me with joy, I must confess, so which will I choose?

Watch this space!

----

## Other Considerations

### The Terraform Lock File

Because of a decision **not** to store the Terraform lock file within the codebase (in the Git repo), the child modules only become aware of which provider version to use when the deployment pipeline runs against the root module.

TODO: Look again at this decision - did it have any basis in fact e.g. is it considered best practice for Terraform pipeline deployments?

----

## Acknowledgments

- <https://www.terraform.io/language/providers/requirements#best-practices-for-provider-versions>
- <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs>
- <https://stackoverflow.com/questions/67160690/terraform-upgrade-and-multiple-versions-tf-do-child-modules-inherit-the-provide>
