

# Create monitoring Resource Group
resource "azurecaf_name" "rg_monitor" {
  name          = "monitor"
  resource_type = "azurerm_resource_group"
  prefixes      = [var.customer_shortname, var.environment_shortname]
}

resource "azurerm_resource_group" "rg_monitor" {
  name     = azurecaf_name.rg_monitor.result
  location = var.location
  tags     = merge(local.common_tags, local.extra_tags)
}

# Create Log Analytics Workspace
resource "azurecaf_name" "la_monitor_log01" {
  name          = "log01"
  resource_type = "azurerm_log_analytics_workspace"
  prefixes      = [var.customer_shortname, var.environment_shortname]
  random_length = 4
  clean_input   = true
}

resource "azurerm_log_analytics_workspace" "la_monitor_log01" {
  name                = azurecaf_name.la_monitor_log01.result
  location            = azurerm_resource_group.rg_monitor.location
  resource_group_name = azurerm_resource_group.rg_monitor.name
  sku                 = "PerGB2018"
  retention_in_days   = var.la_monitor_log01_retention
  tags                = merge(local.common_tags, local.extra_tags)
}


# Add solutions to Log Analytics
locals {
  solution_list = keys(var.la_solution_plan_map)
}

resource "azurerm_log_analytics_solution" "la_monitor_log01_solution" {
  for_each = var.la_solution_plan_map

  solution_name         = each.key
  location              = azurerm_resource_group.rg_monitor.location
  resource_group_name   = azurerm_resource_group.rg_monitor.name
  workspace_resource_id = azurerm_log_analytics_workspace.la_monitor_log01.id
  workspace_name        = azurerm_log_analytics_workspace.la_monitor_log01.name
  tags                  = merge(local.common_tags, local.extra_tags)

  plan {
    product   = each.value.product
    publisher = each.value.publisher
  }
}

resource "azurerm_log_analytics_linked_service" "la_monitor_log01_link_aut" {
  resource_group_name = azurerm_resource_group.rg_monitor.name
  workspace_id        = azurerm_log_analytics_workspace.la_monitor_log01.id
  read_access_id      = azurerm_automation_account.automation01.id
}