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
      version = "~> 2.0.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = ">= 1.1.3"
    }
  }

  backend "azurerm" {
    resource_group_name  = "testtormod-h-rg-tfstate"
    storage_account_name = "testtormodsshsttfstate"
    container_name       = "afvnmgmt"
    key                  = "afvnmgmt.tfstate"
  }

}

resource "azuread_group" "subscription_owner_group_1" {
    display_name     = "subscription_owner_group_1"
    mail_enabled     = false
    security_enabled = true
}

module "pim_assignment_1" {
    source = ".//PIM"

    principal_id = azuread_group.subscription_owner_group_1.object_id
    role_definition_name = "Owner"
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}



