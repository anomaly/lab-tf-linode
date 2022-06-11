# Terraform Input variables let you customize aspects of Terraform 
# modules without altering the module's own source code. This allows 
# you to share modules across different Terraform configurations, 
# making your module composable and reusable.
#
# https://www.terraform.io/language/values/variables
#

# The following are declarations for Linode's infrasructure suited
# to what Anomaly require for their deployments.

# Applicaiton level variables, that are used to name/label various
# resources in the infrastructure.

# Top level domain that the application is associated with, this
# is not necessarily the sub domain the app is served from
variable "app_tld" {
  description = "Top level domain that the applicaiton is associated with (required)"
  type = string
}

variable "app_subdomain" {
  description = "Subdomain that the application is served from (required)"
  type = string
  default = "www"  
}

# Identifies a Linode API key with all access
variable "linode_token" {
  description = "A Linode API key with apporpirate access"
  type        = string
}
