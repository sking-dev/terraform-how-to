data "azurerm_client_config" "current" {}

data "azurerm_dns_zone" "acme_poc_challenge" {
  name                = "DNS_zone_name_goes_here"
  resource_group_name = "DNS_zone_RG_name_goes_here"
}
