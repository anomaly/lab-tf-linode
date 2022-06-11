# Object store related variables
# Identifies a Linode API key with all access
variable "linode_token" {
  description = "A Linode API key with apporpirate access"
  type        = string
}


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

variable "object_store_cluster_id" {
  description = "The ID of the object store cluster (locaiton) to use. (required)"
  default = "ap-south-1"
}
