# Use variables to customise the deployment

variable "customer_shortname" {
  type = string
}

variable "environment_shortname" {
  type = string
}

variable "location" {
  type = string
}

variable "la_monitor_log01_retention" {
  type        = number
  description = "The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
}

variable "tagManagedBy" {
  type = string
}

variable "tagManagementLevel" {
  type = string
}

variable "tagEnvironment" {
  type = string
}

variable "tagServiceName" {
  type = string
}

variable "tagCostCenter" {
  type = string
}

variable "aadGroupPrefix" {
  type        = string
  default     = "acl-az"
  description = "Prefix for all groups that are created i Azure Active Directory for access management, defaults to: acl-az"
}

variable "la_solution_plan_map" {
  description = "(Optional) Map structure containing the list of solutions to be enabled."
  type        = map(any)
  default = {
    Updates = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/Updates"
    },
    ChangeTracking = {
      "publisher" = "Microsoft"
      "product"   = "OMSGallery/ChangeTracking"
    }
  }
}
