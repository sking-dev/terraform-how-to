# How to Import Existing Infrastructure into Terraform IaC

WIP (2022-03-08)

## Objective

As an IaC engineer, I'd like to be able to import existing Azure resources into my IaC and bring them under Terraform control.

These existing resources can be hand-crafted or deployed via other forms of IaC e.g. ARM templates.

Either way, the goal is to make Terraform the "place of truth" for these resources going forward.

----

## terraformer

For quite a while, Terraform hasn't had this capability natively, which some people consider to be a significant weakness of the product.

TODO: Check this as things may have changed in the latest release of Terraform (1.1.x)

So we'll need to look at third party solutions.

The most likely contender from my research so far is 'terraformer'.

TODO: Check out the following links.

- <https://github.com/GoogleCloudPlatform/terraformer#installation>
- <https://mateuszdzierzcki.medium.com/how-to-export-existing-infrastructure-to-terraform-code-d8bd5bc43574>
- <https://www.infrakloud.com/2020/08/import-existing-resources-as-terraform-using-terraformer/>
- <https://faun.pub/terraformer-5036241f90cc>
