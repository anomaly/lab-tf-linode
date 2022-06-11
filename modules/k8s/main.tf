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
