# Configure Terraform to set the required AzureRM provider
# version and features{} block.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.34.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 1.6.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.1.3"
    }
  }

  backend "azurerm" {
    resource_group_name  = "testtormod-h-rg-tfstate"
    storage_account_name = "testtormodsshsttfstate"
    container_name       = "afvncore"
    key                  = "afvncore.tfstate"
  }

}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
#test
# Use Azure AD Graph to support better access management
#provider "azuread" {
#  use_microsoft_graph = true
#}
