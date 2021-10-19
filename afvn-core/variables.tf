# Use variables to customise the deployment

variable "root_id" {
  type = string
}

variable "root_name" {
  type = string
}

variable "location_default" {
  type = string

}

variable "listOfAllowedLocations" {
}

variable "log_analytics_subscriptionid" {
  type = string
}

variable "log_analytics_resourcegroupname" {
  type = string
}

variable "log_analytics_workspacename" {
  type = string
}

variable "asc_email_security_contact" {
  type = string
}

# Subscriptions Lists
variable "subs_decommissioned" {}
variable "subs_sandboxes" {}
variable "subs_connectivity" {}
variable "subs_management" {}
variable "subs_identity" {}
variable "subs_managed_iaas_1" {}
variable "subs_managed_paas_1" {}


variable "aadGroupPrefix" {
  type        = string
  default     = "acl-az"
  description = "Prefix for all groups that are created i Azure Active Directory for access management, defaults to: acl-az"
}