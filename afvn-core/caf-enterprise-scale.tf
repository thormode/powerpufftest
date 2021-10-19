# Enterprise-scale and provide a base configuration.
# Doc: https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "0.3.3"

  root_parent_id   = data.azurerm_client_config.current.tenant_id
  root_id          = var.root_id
  root_name        = var.root_name
  library_path     = "${path.root}/lib"
  default_location = var.location_default

  # Override parameters for esc terraform module 
  archetype_config_overrides = {
    root = {
      archetype_id = "es_root"
      parameters = {
        Deny-Resource-Locations = {
          listOfAllowedLocations = var.listOfAllowedLocations
        },
        Deploy-VM-Monitoring = {
          logAnalytics_1 = "/subscriptions/${var.log_analytics_subscriptionid}/resourcegroups/${var.log_analytics_resourcegroupname}/providers/Microsoft.OperationalInsights/workspaces/${var.log_analytics_workspacename}"
        },
        Deploy-VMSS-Monitoring = {
          logAnalytics_1 = "/subscriptions/${var.log_analytics_subscriptionid}/resourcegroups/${var.log_analytics_resourcegroupname}/providers/Microsoft.OperationalInsights/workspaces/${var.log_analytics_workspacename}"
        },
        Deploy-Resource-Diag = {
          logAnalytics = "/subscriptions/${var.log_analytics_subscriptionid}/resourcegroups/${var.log_analytics_resourcegroupname}/providers/Microsoft.OperationalInsights/workspaces/${var.log_analytics_workspacename}"
        },
        Deploy-AzActivity-Log = {
          logAnalytics = "/subscriptions/${var.log_analytics_subscriptionid}/resourcegroups/${var.log_analytics_resourcegroupname}/providers/Microsoft.OperationalInsights/workspaces/${var.log_analytics_workspacename}"
        },
        Deploy-Nsg-FlowLogs = {
          workspace = "/subscriptions/${var.log_analytics_subscriptionid}/resourcegroups/${var.log_analytics_resourcegroupname}/providers/Microsoft.OperationalInsights/workspaces/${var.log_analytics_workspacename}"
        }
      }
      access_control = {
      }
    },
    platform = {
      archetype_id = "es_platform"
      parameters = {
        Deploy-ASC-Defender = {
          logAnalytics         = "/subscriptions/${var.log_analytics_subscriptionid}/resourcegroups/${var.log_analytics_resourcegroupname}/providers/Microsoft.OperationalInsights/workspaces/${var.log_analytics_workspacename}"
          emailSecurityContact = var.asc_email_security_contact
        }
      }
      access_control = {}
    }
  }

  custom_landing_zones = {
    "${var.root_id}-traditional" = {
      display_name               = "${upper(var.root_id)} Traditional"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = var.subs_managed_iaas_1
      archetype_config = {
        archetype_id = "managed_iaas"
        parameters = {
          Deploy-ASC-Defender = {
            logAnalytics         = "/subscriptions/${var.log_analytics_subscriptionid}/resourcegroups/${var.log_analytics_resourcegroupname}/providers/Microsoft.OperationalInsights/workspaces/${var.log_analytics_workspacename}"
            emailSecurityContact = var.asc_email_security_contact
          }
        }
        access_control = {}
      }
    },
    "${var.root_id}-cloudnative" = {
      display_name               = "${upper(var.root_id)} Cloud Native"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = var.subs_managed_paas_1
      archetype_config = {
        archetype_id = "managed_paas"
        parameters = {
          Deploy-ASC-Defender = {
            logAnalytics         = "/subscriptions/${var.log_analytics_subscriptionid}/resourcegroups/${var.log_analytics_resourcegroupname}/providers/Microsoft.OperationalInsights/workspaces/${var.log_analytics_workspacename}"
            emailSecurityContact = var.asc_email_security_contact
          }
        }
        access_control = {}
      }
    }
  }

  # Move azure foundation subscriptions
  subscription_id_overrides = {
    decommissioned = var.subs_decommissioned
    sandboxes      = var.subs_sandboxes
    connectivity   = var.subs_connectivity
    management     = var.subs_management
    identity       = var.subs_identity
  }

}


output "esc_mgmt" {
  value = module.enterprise_scale.azurerm_management_group
}
