# Create resource group per ACME POC environment.
resource "azurerm_resource_group" "acme_poc" {
  name     = "rg-${local.region_short}-acme-poc-${var.environment_name}"
  location = var.location

  tags = merge(local.default_tags, var.custom_tags)
}
