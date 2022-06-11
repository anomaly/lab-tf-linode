# The Linode provider requires an API token that you can
# generate using the linode-cli (check README)
# https://registry.terraform.io/providers/linode/linode/latest/docs
#
# This is ultimately stored in Terraform cloud

provider "linode" {
    token = var.linode_token
}

# Each modules has a terraform block and defines what providers
# it requires to use so you can expect to see the helm providers
# in the other configuraiton files
terraform {
    # We use the Linode provider to speak with their v4 API
    # subsequently we will use the Kubernetes provider to
    # provision applications into the cluster
    required_providers {
        linode = {
            source  = "linode/linode"
            version = "~> 1.20"
        }
    }
}

# This file defines a Kubernetes cluster that will be provisioned
# on linode's infrasrtructure, note that you will have to provide
# the values for your cluster
resource "linode_lke_cluster" "cluster_k8s" {
    label = var.k8s_label
    k8s_version = var.k8s_version
    region = var.k8s_region
    tags = var.k8s_tags

    dynamic "pool" {
        for_each = var.k8s_pool
        content {
            type  = pool.value["type"]
            count = pool.value["count"]
        }
    }
}
