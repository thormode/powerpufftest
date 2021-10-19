# Managment main file
data "azurerm_client_config" "current" {}

module "management" {
  source = "./modules/tf-module-azure-afvn-management"

  customer_shortname         = var.customer_shortname
  environment_shortname      = var.environment_shortname
  location                   = var.location
  tagManagedBy               = var.tagManagedBy
  tagManagementLevel         = var.tagManagementLevel
  tagEnvironment             = var.tagEnvironment
  tagServiceName             = var.tagServiceName
  tagCostCenter              = var.tagCostCenter
  la_monitor_log01_retention = var.la_monitor_log01_retention

}