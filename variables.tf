# Terraform Input variables let you customize aspects of Terraform 
# modules without altering the module's own source code. This allows 
# you to share modules across different Terraform configurations, 
# making your module composable and reusable.
#
# https://www.terraform.io/language/values/variables
#

# The following are declarations for Linode's infrasructure suited
# to what Anomaly require for their deployments.

# Identifies a Linode API key with all access
variable "provider_token" {
    description = "A Linode API key with apporpirate access"
    type        = string
}
