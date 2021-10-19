# Customer Variables
# This file will contain all variables that the terraform need as input to deploy the terraform code

# Managment Groups
root_id   = "tormodtest"               # Short Name of the top Managment Group 
root_name = "Standardmappe tormodtest" # Displayname of the to Managment Group

# Subscriptions
## ESC Management Groups
subs_decommissioned = []
subs_sandboxes      = []
subs_connectivity   = []
subs_management     = ["981c0247-9dfc-41d2-9204-9863db272c6e"]
subs_identity       = []

## Custom Managment Groups
subs_managed_iaas_1 = []
subs_managed_paas_1 = []

# Default variables
location_default       = "westeurope"
listOfAllowedLocations = ["norwayeast", "norwaywest", "westeurope", "northeurope"]

# Log Analytics
log_analytics_subscriptionid    = "981c0247-9dfc-41d2-9204-9863db272c6e"
log_analytics_resourcegroupname = "testtormod-h-rg-monitor"
log_analytics_workspacename     = "testtormod-h-log-log01-bsyr"

# Azure Security Center
asc_email_security_contact = "tormodtjaaland@gmail.com"