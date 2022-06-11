# Identifies a Linode API key with all access
variable "linode_token" {
  description = "A Linode API key with apporpirate access"
  type        = string
}

# The following variables related to the Kubernetes cluster
# that will be provisioned for your application, vary these
# values via your terraform.tfvars file.
#
# Based on the template provided by Linode's docs
# https://www.linode.com/docs/guides/how-to-deploy-an-lke-cluster-using-terraform/
variable "k8s_version" {
  description = "The Kubernetes version to use for this cluster. (required)"
  default = "1.23"
}

variable "k8s_label" {
  description = "The unique label to assign to this cluster. (required)"
}

variable "k8s_region" {
  description = "The region where your cluster will be located. (required)"
  default = "ap-southeast"
}

variable "k8s_tags" {
  description = "Tags to apply to your cluster for organizational purposes. (optional)"
  type = list(string)
  default = ["testing"]
}

variable "k8s_pool" {
  description = "The Node Pool specifications for the Kubernetes cluster. (required)"
  type = list(object({
    type = string
    count = number
  }))
  default = [
    {
      type = "g6-standard-1"
          count = 3
    }
  ]
}
