# We output the following variables from the Terraform state
# as the project progresses we might not need to see these
# and automate provisioning as far as possible
output "k8s_kubeconfig" {
   value = base64decode(linode_lke_cluster.cluster_k8s.kubeconfig)
   sensitive = true
}

output "k8s_api_endpoints" {
   value = linode_lke_cluster.cluster_k8s.api_endpoints
}

output "k8s_status" {
   value = linode_lke_cluster.cluster_k8s.status
}

output "k8s_id" {
   value = linode_lke_cluster.cluster_k8s.id
}

output "k8s_pool" {
   value = linode_lke_cluster.cluster_k8s.pool
}
