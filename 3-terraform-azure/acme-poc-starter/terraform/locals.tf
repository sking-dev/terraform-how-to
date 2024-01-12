locals {
  # Generate short version of Azure location to use in resource naming.
  region_short = var.location == "uksouth" ? "uks" : "ukw"

  # Repoint local variable from this module to input variable in /environment-variables directory.
  default_tags = var.tags

  # Create a basic object map for "certificates" list.
  certificates_map = { for object in var.certificates : object.name => object }

  # The common name prefix should be null in LIV (not required) & set to "npr." in NPR.
  certificate_common_name_prefix = var.environment_name == "liv" ? "" : "${var.environment_name}." # The "dot" is supported in common name

  # The Key Vault certificate & secret name prefix should be null in LIV (not required) & set to "npr-" in NPR.
  certificate_key_vault_name_prefix = var.environment_name == "liv" ? "" : "${var.environment_name}-" # "Dot" not supported in KV object name so use "dash" instead
}
