# Objective was to populate an IP group with values from a CSV file.
# No success thus far (boo!)

# https://www.terraform.io/language/functions/csvdecode
# locals {
#   instances = csvdecode(file("files/o365_endpoints_ips_only.csv"))
# }

# output "locals_instances" {
#   value = local.instances
# }

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/ip_group
resource "azurerm_ip_group" "test-one" {
  name                = "azure-firewall-ipgroup-test-one"
  location            = var.location
  resource_group_name = var.resource_group_test

  cidrs = ["192.168.0.1", "172.16.240.0/20", "10.48.0.0/12"]

  # This doesn't work as it treats each value as a separate 'cidrs' attribute.
  # We want all the values to be incorporated into the same attribute.
  #
  # for_each = { for inst in local.instances : inst.id => inst }
  # cidrs    = [each.value.ips]

  # This doesn't work either because 'cidrs' is *not* a nested configuration block.
  #
  # dynamic "cidrs" {
  #   for_each = { for inst in local.instances : inst.id => inst }
  #   content {
  #     cidrs = [each.value.ips]
  #   }
  # }

  tags = local.default_tags
}

# The 'cidrs' attribute does *not* support FQDNs.
# resource "azurerm_ip_group" "test-two" {
#   for_each            = { for inst in local.instances : inst.id => inst }
#   name                = "azure-firewall-ipgroup-test-two"
#   location            = var.location
#   resource_group_name = var.resource_group_test

#   #cidrs = ["192.168.0.1", "172.16.240.0/20", "10.48.0.0/12"]
#   cidrs = ["outlook.office.com"]

#   tags = local.default_tags
# }
