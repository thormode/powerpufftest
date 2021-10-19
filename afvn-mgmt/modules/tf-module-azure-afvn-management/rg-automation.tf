# Create automation Resource Group
resource "azurecaf_name" "rg_automation" {
  name          = "automation"
  resource_type = "azurerm_resource_group"
  prefixes      = [var.customer_shortname, var.environment_shortname]
}

resource "azurerm_resource_group" "rg_automation" {
  name     = azurecaf_name.rg_automation.result
  location = var.location
  tags     = merge(local.common_tags, local.extra_tags)
}

# Create automation account
resource "azurecaf_name" "automation01" {
  name          = "automation01"
  resource_type = "azurerm_automation_account"
  prefixes      = [var.customer_shortname, var.environment_shortname]
  clean_input   = true
}

resource "azurerm_automation_account" "automation01" {
  name                = azurecaf_name.automation01.result
  location            = azurerm_resource_group.rg_automation.location
  resource_group_name = azurerm_resource_group.rg_automation.name

  sku_name = "Basic"

  tags = merge(local.common_tags, local.extra_tags)
}

# Send logs to Log Analytics
# Required for automation account with update management and/or change tracking enabled.
# Optional on automation accounts used of other purposes.
resource "azurerm_monitor_diagnostic_setting" "automation01_logs" {
  name                       = "LogsToLogAnalytics"
  target_resource_id         = azurerm_automation_account.automation01.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la_monitor_log01.id

  log {
    category = "JobLogs"
    enabled  = true
  }

  log {
    category = "JobStreams"
    enabled  = true
  }

  log {
    category = "DscNodeStatus"
    enabled  = true
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}