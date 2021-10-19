# Managment main file
data "azurerm_client_config" "current" {}

locals {
  common_tags = {
    ManagedBy       = "${var.tagManagedBy}"
    ManagementLevel = "${var.tagManagementLevel}"
    Environment     = "${var.tagEnvironment}"
  }
  extra_tags = {
    ServiceName = "${var.tagServiceName}"
    CostCenter  = "${var.tagCostCenter}"
  }
}
