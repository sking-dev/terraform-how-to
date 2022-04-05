resource "azurerm_firewall" "test-one" {
  name                = "azure-firewall-test-one"
  location            = var.location
  resource_group_name = var.resource_group_test
  firewall_policy_id  = azurerm_firewall_policy.test-one.id


  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.test-one.id
    public_ip_address_id = azurerm_public_ip.test-one.id
  }
}
