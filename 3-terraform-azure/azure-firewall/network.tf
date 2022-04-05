resource "azurerm_virtual_network" "test-one" {
  name                = "testvnet"
  address_space       = ["10.10.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_test

  tags = local.default_tags
}

resource "azurerm_subnet" "test-one" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_test
  virtual_network_name = azurerm_virtual_network.test-one.name
  address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_public_ip" "test-one" {
  name                = "testpip"
  location            = var.location
  resource_group_name = var.resource_group_test
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.default_tags
}
