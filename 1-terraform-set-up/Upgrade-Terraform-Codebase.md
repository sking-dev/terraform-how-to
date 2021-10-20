# Upgrade Terraform Production Codebase

## Objective

As an IaC engineer, I want to keep Terraform as up-to-date as possible but without any negative impact on my Production codebase.

## Terraform Version

As I begin this document, my Production codebase is running under version **0.13.5** of Terraform.
  
By "Production codebase", I mean that this code has been used to deploy resources to a live Azure environment.

So, which version should I upgrade to?

I can check out the link below to see which versions are available.

- <https://github.com/hashicorp/terraform/releases>

If there are no other factors at work, it's generally good practice to adopt the "latest and greatest" version of any application.

For Terraform, this is version **1.0.9** (at the time of writing)

IMPORTANT: It's a good move to follow HashiCorp's best practice for upgrading across major versions.

- <https://www.terraform.io/upgrade-guides/1-0.html>

So...  

The upgrade path to follow in my scenario will be, upgrade 0.13.5 to the latest 0.14 version, which is 0.14.11, and then move on to 1.0.9.

```plaintext
UPDATE:

Real world scenario ahoy!

I'm working with a third party that will be supplying new Terraform code that's been written using version 1.0.6.

I'll need to bring my code up to this version so that it doesn't get out of step.

This means the upgrade path for my existing code becomes 0.13.5 --> 0.14.11 --> 1.0.6 (so *not* 1.0.9 as I originally envisaged)

```

### Constrain Terraform Version

The best practice from HashiCorp is to pin the Terraform major version, and allow all minor versions within that major version.

```hcl
required_version = "~> 1.0.0"
```

This will allow the code to be run under versions 1.0.0 through 1.0.x which allows for easier adoption of minor versions (these are typically releases intended to improve stability and fix bugs)

- <https://learn.hashicorp.com/tutorials/terraform/versions?in=terraform/1-0>

----

## Provider Version

Consideration is also required for the providers that are used within the Terraform code.

The main provider that I'm using is the **azurerm** provider, which is currently at version **2.37.0** in my Production codebase.

So, the question arises here, too: which version should I upgrade to?

I can checkout the link below to see which versions are currently available.

- <https://github.com/hashicorp/terraform-provider-azurerm/releases>

Ideally, I'd like to move to the "latest and greatest" version which is 2.80.0 (at the time of writing) but, because I want to match the version that my third party collaborator will be using, I'll be moving to version **2.79.1** (so not a million miles away!)

```plaintext
NOTE: 

It may be that different services within the codebase require different versions e.g. one service may require a particular version to resolve an issue, but the same version may break the deployment of another service.  

There's a case here for separating out services, in terms of Terraform configuration, to allow for flexibility when doing these upgrades.

If I encounter this during my upgrades, I'll add some details here to clarify this observation.
```

### Constrain Provider Version

It's not clear what HashiCorp best practice is for this (TODO: check this) but it seems reasonable to pin (constrain) each provider to a specific version.

```hcl
required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.79.1"
    }
```

NOTE: Version 0.14 onwards introduces the concept of the dependency lock file, `.terraform.lock.hcl`.

This file can be safely committed to the Git repository as it doesn't contain any sensitive information.

See <https://learn.hashicorp.com/tutorials/terraform/provider-versioning?in=terraform/1-0> for more details.

----

## Upgrade Existing Code

### Workflow for Upgrading an Existing Module

"Existing module" in the sense of, a working directory that contains Terraform code that's been deployed previously to a live environment.

OK, here we go!

#### Upgrade Terraform to Intermediate Version

- Switch to running the new intermediate version of Terraform
  - **0.14.11**
    - NOTE: You can [do this more easily by using tfenv](Run-Multiple-Terraform-Versions-Windows.md)
- Run `terraform init`
- Comment out the provider version constraint in the provider.tf file
  - NOTE: You may not be following this (deprecated) practice in your code
    - If you are, you'll get a warning (see below) about this being deprecated after you run `terraform init`
      - This warning is also seen when running `terraform validate`

```plaintext
Warning: Version constraints inside provider configuration blocks are deprecated

  on provider.tf line 2, in provider "azurerm":
   2:   version = "=2.37.0"

Terraform 0.13 and earlier allowed provider version constraints inside the
provider configuration block, but that is now deprecated and will be removed
in a future version of Terraform. To silence this warning, move the provider
version constraint into the required_providers block.
```

- Add a new file, versions.tf
  - This is where you'll specify your Terraform and provider versions
    - [See below](#nearly-there) for an example of the layout of this file
- Run `terraform plan`
  - The Terraform console doesn't give any acknowledgment of the new version at this point
- Run `terraform apply`
  - Again, no acknowledgment of the new version at this point
    - BUT the version number _is_ updated in the remote state file after this operation

#### Upgrade Provider

- Upgrade the `azurerm` provider version in the versions.tf file
  - Change the value from "=2.37.0" to "=2.79.1"
- Any operation after this - e.g. `terraform plan` - will prompt you to run `terraform init` to install the new provider version (see below)
  - BUT be aware that the correct command to run at this point is `terraform init -upgrade`

```plaintext
Error: Provider requirements cannot be satisfied by locked dependencies

The following required providers are not installed:

- registry.terraform.io/hashicorp/azurerm (2.79.1)

Please run "terraform init".
```

#### Upgrade Terraform to Target Version

- Switch to running the target new version of Terraform
  - **1.0.6**
    - Again, I'd recommend that you [do this via tfenv](Run-Multiple-Terraform-Versions-Windows.md)
- Run `terraform plan`
  - This will prompt you to run `terraform init`
    - BUT it will also flag that the backend configuration has changed
      - "WTF!"

```plaintext
Error: Backend initialization required, please run "terraform init"

Reason: Backend configuration changed for "azurerm"

The "backend" is the interface that Terraform uses to store state, perform operations, etc. If this message is showing up, it means that the Terraform configuration you're using is using a custom configuration for the Terraform backend.

Changes to backend configurations require reinitialization. This allows Terraform to set up the new configuration, copy existing state, etc. Please run "terraform init" with either the "-reconfigure" or "-migrate-state" flags to use the current configuration.

If the change reason above is incorrect, please verify your configuration hasn't changed and try again. At this point, no changes to your existing configuration or state have been made.
```

- So...  
  - Try running `terraform init` to reinitialise the backend as-is
    - BUT...  This doesn't do the trick (boo!)

```plaintext
Initializing the backend...

Error: Backend configuration changed

A change in the backend configuration has been detected, which may require migrating existing state.

If you wish to attempt automatic migration of the state, use "terraform init -migrate-state".
If you wish to store the current configuration with no changes to the state, use "terraform init -reconfigure".
```

#### This is What to Do

- Run `terraform init -reconfigure` to continue to use the backend as-is
  - The HashiCorp documentation is misleading on this point and seems to suggest that this will start state from scratch
    - _The -reconfigure option disregards any existing configuration, preventing migration of any existing state._
      - <https://www.terraform.io/docs/cli/commands/init.html#backend-initialization>
  - BUT I've tested this in a sandbox environment (hooray!) and it does preserve and continue to use the existing state (phew!)
    - Thanks to <https://github.com/hashicorp/terraform/issues/29390> for the reassurance on this point

```plaintext
Initializing the backend...

Successfully configured the backend "azurerm"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Reusing previous version of hashicorp/azurerm from the dependency lock file
- Using previously-installed hashicorp/azurerm v2.79.1

Terraform has been successfully initialized!
```

#### Nearly There

- Constrain the Terraform version to any 1.0.x version
  - This will allow for easy adoption of any new minor release whilst prohibiting the use of any later major release
    - Update your versions.tf file (see below)

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      #version = "=2.37.0"
      version = "=2.79.1"
    }
  }

  #required_version = ">= 0.13.5"
  #required_version = ">=0.14.11"
  required_version = "~> 1.0.0"
}
```

- Run `terraform plan`
  - The Terraform console doesn't flag up any version change
- Run `terraform apply`
  - Again, the Terraform console doesn't flag up any version change
    - BUT after this operation, the value for `"terraform_version"` _is_ updated in the state file (see the excerpt below for proof!)

```json
{
  "version": 4,
  "terraform_version": "1.0.6",
  "serial": 5,
  .
  .
  .
}
```

----

And that, as they say, should be that - until the next time!

----

## END of Upgrade Terraform Production Codebase
