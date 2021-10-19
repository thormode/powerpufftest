# Customer Variables
# This file will contain all variables that the terraform need as input to deploy the terraform code


# Customer Naming Variables
customer_shortname    = "Standard"
environment_shortname = "h"

# Default variables
location = "westeurope"

## Azure Tags
### Common Tags
tagManagedBy       = "gha afvn-mgmt" # Reference to the pipeline/action that is managing the resource group (gha="github actions", azp="azure pipelines").
tagManagementLevel = "Managed"       # Mark if managed by TE
tagEnvironment     = "Production"

### Extra Tags
tagServiceName = "Azure Foundation"
tagCostCenter  = "Azure Foundation"


# Monitoring
## Log Analytics
la_monitor_log01_retention = 30 # Dataretention in days the log01 workspace will hold data


