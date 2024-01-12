terraform {
  required_version = "~> 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.63.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
  }
}

# Default Azure subscription for deployments.
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

# TODO: Move URL values to variables.
provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  #server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
