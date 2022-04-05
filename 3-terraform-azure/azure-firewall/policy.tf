# Deploy Azure Firewall policy.
resource "azurerm_firewall_policy" "test-one" {
  name                = "azure-firewall-test-one-policy"
  resource_group_name = var.resource_group_test
  location            = var.location
}
