# Basic end-to-end preliminary test #2.
# Generate a batch of ACME certificates from Let's Encrypt staging environment.
# DNS integration with test public DNS zone in Azure.
# Resulting certificates to be stored in "npr" and "liv" key vaults (with Common Name to match each environment)

# See provider.tf for "acme" provider.
# NOTE: The provider resource block includes the URL for the ACME server.

# See data.tf for data source block for existing public DNS zone.

# Create private key in PEM format.
resource "tls_private_key" "private_key_2" {
  algorithm = "RSA"
}

# Create account on ACME server using private key plus email address.
resource "acme_registration" "acme_poc_test_2" {
  account_key_pem = tls_private_key.private_key_2.private_key_pem
  email_address   = var.acme_registration_email
}

# Create password for certificate's PFX file.
resource "random_password" "acme_poc_test_2" {
  for_each = local.certificates_map
  length   = 24
  special  = true
}

# Get a certificate from ACME server.
resource "acme_certificate" "acme_poc_test_2" {
  for_each                 = local.certificates_map
  account_key_pem          = acme_registration.acme_poc_test_2.account_key_pem
  common_name              = "${local.certificate_common_name_prefix}${each.value.name}.domain-name.com"
  certificate_p12_password = random_password.acme_poc_test_2[each.key].result

  dns_challenge {
    provider = "azure"

    config = {
      AZURE_RESOURCE_GROUP = data.azurerm_dns_zone.acme_poc_challenge.resource_group_name
      AZURE_ZONE_NAME      = data.azurerm_dns_zone.acme_poc_challenge.name
      AZURE_TTL            = 300
    }
  }
}

# Extend the blog post example by copying the ACME-generated certificate to Azure Key Vault.
# NOTE: The name of the certificate in KV should probably match the common name (site name)
resource "azurerm_key_vault_certificate" "acme_poc_test_2" {
  for_each     = local.certificates_map
  name         = "${local.certificate_key_vault_name_prefix}${each.value.name}-domain-name-com-cert"
  key_vault_id = azurerm_key_vault.acme_poc.id

  certificate {
    contents = acme_certificate.acme_poc_test_2[each.key].certificate_p12
    password = acme_certificate.acme_poc_test_2[each.key].certificate_p12_password
  }
}

# TODO: Establish if secret is explicitly required in AGW context.
# NOTE: The name of the secret should probably match up with the common name (site name)
resource "azurerm_key_vault_secret" "acme_poc_test_2" {
  for_each     = local.certificates_map
  name         = "${local.certificate_key_vault_name_prefix}${each.value.name}-domain-name-com-secret"
  value        = acme_certificate.acme_poc_test_2[each.key].certificate_p12_password
  key_vault_id = azurerm_key_vault.acme_poc.id
}
