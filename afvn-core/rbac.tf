# Create and assign groups for reader access on the different management group levels

## Reader groups
### Create the AAD Reader groups
resource "azuread_group" "azurerm_management_group_reader" {
  for_each         = module.enterprise_scale.azurerm_management_group.enterprise_scale
  display_name     = "${var.aadGroupPrefix}-mgmt-${each.value.name}-reader"
  description      = "Reader access to ${each.value.name} Azure Management Group"
  security_enabled = true
}

## Assign the groups to the managements groups with the Reader role
resource "azurerm_role_assignment" "azurerm_management_group_reader" {
  for_each             = azuread_group.azurerm_management_group_reader
  scope                = each.key
  role_definition_name = "Reader"
  principal_id         = each.value.object_id
}

## Owner groups
### Create the AAD Owner groups
resource "azuread_group" "azurerm_management_group_owner" {
  for_each         = module.enterprise_scale.azurerm_management_group.enterprise_scale
  display_name     = "${var.aadGroupPrefix}-mgmt-${each.value.name}-owner"
  description      = "Owner access to ${each.value.name} Azure Management Group"
  security_enabled = true
}

## Assign the groups to the managements groups with the Owner role
resource "azurerm_role_assignment" "azurerm_management_group_owner" {
  for_each             = azuread_group.azurerm_management_group_owner
  scope                = each.key
  role_definition_name = "Owner"
  principal_id         = each.value.object_id
}

## Contributor groups
### Create the AAD Contributor groups
resource "azuread_group" "azurerm_management_group_contrib" {
  for_each         = module.enterprise_scale.azurerm_management_group.enterprise_scale
  display_name     = "${var.aadGroupPrefix}-mgmt-${each.value.name}-contrib"
  description      = "Contributor access to ${each.value.name} Azure Management Group"
  security_enabled = true
}

## Assign the groups to the managements groups with the Contributor role
resource "azurerm_role_assignment" "azurerm_management_group_contrib" {
  for_each             = azuread_group.azurerm_management_group_contrib
  scope                = each.key
  role_definition_name = "Contributor"
  principal_id         = each.value.object_id
}



