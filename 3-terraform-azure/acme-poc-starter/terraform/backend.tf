terraform {
  backend "azurerm" {
    resource_group_name  = "Terraform_state_RG_name_goes_here"
    storage_account_name = "Terraform_state_SA_name_goes_here"
    container_name       = "terraform-state"
    # IMPORTANT: Only the NPR environment should be modified when running Terraform locally.
    key = "ts-acme-poc-starter-npr.tfstate"
  }
}
