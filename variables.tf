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

# Defines a list of Linode instances
variable "instances" {
    description = "A Linode virtual machine instance"
    type = map(object({
        image            = string
        label            = string
        tags             = list(string)
        region           = string
        type             = string
        authorized_keys  = list(string)
        authorized_users = list(string)
        backups_enabled  = bool
        stackscript_id   = number
        ipam_address     = string
    }))

  # TODO: Validate that ipam_address is unique
  # TODO: Better error messages for each error
  validation {
    condition = alltrue([
      for o in var.instances : length(regexall("(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}/[0-9]{2}", o.ipam_address)) > 0
      ],
    ) && contains(keys(var.instances), "db") && contains(keys(var.instances), "server")
    error_message = "Invalid instance object."
  }
}

