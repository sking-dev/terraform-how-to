# Create Key Vault resource.
resource "azurerm_key_vault" "acme_poc" {
  name                       = "kv-${local.region_short}-acme-poc-${var.environment_name}"
  location                   = var.location
  resource_group_name        = azurerm_resource_group.acme_poc.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 90
  purge_protection_enabled   = true
  sku_name                   = "standard"

  enable_rbac_authorization       = false
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true

  # Create Access Policy for the Terraform deployment SPN.
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "ManageContacts",
      "ManageIssuers",
      "GetIssuers",
      "ListIssuers",
      "SetIssuers",
      "DeleteIssuers",
      "Purge",
    ]

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set",
    ]

    storage_permissions = [
      "Get",
    ]
  }

  # Create contact to recieve notifications e.g. certificate expiry.
  contact {
    email = "contact_email_address_goes_here"
  }

  # TODO: Set 'default_action' to "Deny" for when no rules match from 'ip_rules' / 'virtual_network_subnet_ids'.
  # NOTE: This is problematic for hosted pipeline build agents but should be easier for self-hosted agents.
  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  timeouts {}

  tags = merge(local.default_tags, var.custom_tags)
}
