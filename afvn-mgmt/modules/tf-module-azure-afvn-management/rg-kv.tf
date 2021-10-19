# Create KeyVault Resource Group
resource "azurecaf_name" "rg_keyvault01" {
  name          = "keyvault"
  resource_type = "azurerm_resource_group"
  prefixes      = [var.customer_shortname, var.environment_shortname]
}

resource "azurerm_resource_group" "rg_keyvault01" {
  name     = azurecaf_name.rg_keyvault01.result
  location = var.location
  tags     = merge(local.common_tags, local.extra_tags)
}

# Create KeyVault
resource "azurecaf_name" "kv_keyvault01" {
  name          = "mgmt1"
  resource_type = "azurerm_key_vault"
  prefixes      = [var.customer_shortname, var.environment_shortname]
  clean_input   = true
  random_length = 4
}

resource "azuread_group" "kv_keyvault01_aad_mgmt_group" {
  display_name = "${var.aadGroupPrefix}-${azurecaf_name.kv_keyvault01.result}-management"
  description  = "Give KeyVault Management access to ${azurecaf_name.kv_keyvault01.result} KeyVault"
  security_enabled = true
}

resource "azurerm_key_vault" "kv_keyvault01" {
  name                       = azurecaf_name.kv_keyvault01.result
  location                   = azurerm_resource_group.rg_keyvault01.location
  resource_group_name        = azurerm_resource_group.rg_keyvault01.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  sku_name = "standard"
  tags     = merge(local.common_tags, local.extra_tags)

  # Add terrafor spn for acceess Keyvault AAD Group
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azuread_group.kv_keyvault01_aad_mgmt_group.object_id

    key_permissions = [
      "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Recover", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"
    ]

    secret_permissions = [
      "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
    ]

    storage_permissions = [
      "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"
    ]

    certificate_permissions = [
      "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"
    ]
  }

  # Add terrafor spn for acceess Keyvault AAD Group
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Recover", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey"
    ]

    secret_permissions = [
      "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
    ]

    storage_permissions = [
      "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update"
    ]

    certificate_permissions = [
      "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update"
    ]
  }
}

# Send logs to Log Analytics
resource "azurerm_monitor_diagnostic_setting" "kv_keyvault01_logs" {
  name                       = "LogsToLogAnalytics"
  target_resource_id         = azurerm_key_vault.kv_keyvault01.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la_monitor_log01.id

  log {
    category = "AuditEvent"
    enabled  = true
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Create Operator Secret
resource "azurecaf_name" "kv_sec_operator_password" {
  name          = "operator-password"
  resource_type = "azurerm_key_vault_secret"
  prefixes      = [var.customer_shortname, var.environment_shortname]
  clean_input   = true
}

resource "random_password" "operator-password" {
  length           = 16
  special          = true
  override_special = "_%@"
  min_upper        = 1
  min_lower        = 1
  min_special      = 1
  min_numeric      = 1
}

resource "azurerm_key_vault_secret" "kv_sec_operator_password" {
  name         = azurecaf_name.kv_sec_operator_password.result
  value        = random_password.operator-password.result
  key_vault_id = azurerm_key_vault.kv_keyvault01.id
  tags         = merge(local.common_tags, local.extra_tags)
}
