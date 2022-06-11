
# We output the following variables from the Terraform state
# as the project progresses we might not need to see these
# and automate provisioning as far as possible
output "k8s_kubeconfig" {
   value = base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)
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


# The web client secrets will be used to copy files into the
# bucket when we release a new version of the application
output "key_accesss_bucket_web_client" {
    value = linode_object_storage_key.key-bucket-web-client.access_key
    sensitive = true
}

output "key_secret_bucket_web_client" {
    value = linode_object_storage_key.key-bucket-web-client.secret_key
    sensitive = true
}

# Outputs the access and secret key for both buckets
# these are required by the application to store and retrieve files
output "key_accesss_bucket_file_store" {
    value = linode_object_storage_key.key-bucket-file-store.access_key
    sensitive = true
}

output "key_secret_bucket_file_store" {
    value = linode_object_storage_key.key-bucket-file-store.secret_key
    sensitive = true
}
