# This file defines a Kubernetes cluster that will be provisioned
# on linode's infrasrtructure, note that you will have to provide
# the values for your cluster
resource "linode_lke_cluster" "k8s-cluster" {
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

# Awaits the completion of creation of the K8s cluster
# this is to assist the other resources not to get ahead
# of the creation of the cluster
resource "time_sleep" "wait_for_kubernetes" {
    depends_on = [
        linode_lke_cluster.k8s-cluster
    ]
    create_duration = "20s"
}

# We output the following variables from the Terraform state
# as the project progresses we might not need to see these
# and automate provisioning as far as possible
output "k8s_kubeconfig" {
   value = linode_lke_cluster.k8s-cluster.kubeconfig
   sensitive = true
}

output "k8s_api_endpoints" {
   value = linode_lke_cluster.k8s-cluster.api_endpoints
}

output "k8s_status" {
   value = linode_lke_cluster.k8s-cluster.status
}

output "k8s_id" {
   value = linode_lke_cluster.k8s-cluster.id
}

output "k8s_pool" {
   value = linode_lke_cluster.k8s-cluster.pool
}
    