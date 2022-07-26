
# We output the following variables from the Terraform state
# as the project progresses we might not need to see these
# and automate provisioning as far as possible
output "k8s_kubeconfig" {
   value = base64decode(linode_lke_cluster.primary.kubeconfig)
   sensitive = true
}

output "k8s_api_endpoints" {
   value = linode_lke_cluster.primary.api_endpoints
}

output "k8s_status" {
   value = linode_lke_cluster.primary.status
}

output "k8s_id" {
   value = linode_lke_cluster.primary.id
}

output "k8s_pool" {
   value = linode_lke_cluster.primary.pool
}

# Bucket name, hostname and region for access


# The web client secrets will be used to copy files into the
# bucket when we release a new version of the application
output "key_access_bucket_web_client" {
    value = linode_object_storage_key.web_client.access_key
    sensitive = true
}

output "key_secret_bucket_web_client" {
    value = linode_object_storage_key.web_client.secret_key
    sensitive = true
}

output "label_bucket_web_client" {
    value = linode_object_storage_bucket.web_client.label
}

output "cluster_bucket_web_client" {
    value = linode_object_storage_bucket.web_client.cluster
}

output "dns_bucket_web_client" {
    value = "${linode_object_storage_bucket.web_client.label}.${linode_object_storage_bucket.web_client.cluster}.linodeobjects.com"
}

# Outputs the access and secret key for both buckets
# these are required by the application to store and retrieve files
output "key_access_bucket_file_store" {
    value = linode_object_storage_key.file_store.access_key
    sensitive = true
}

output "key_secret_bucket_file_store" {
    value = linode_object_storage_key.file_store.secret_key
    sensitive = true
}

output "label_bucket_file_store" {
    value = linode_object_storage_bucket.file_store.label
}

output "cluster_bucket_file_store" {
    value = linode_object_storage_bucket.file_store.cluster
}

output "dns_bucket_file_store" {
    value = "${linode_object_storage_bucket.file_store.label}.${linode_object_storage_bucket.file_store.cluster}.linodeobjects.com"
}

# Postgres managed database
# output "db_host_primary" {
#     value = linode_database_postgresql.primary.host_primary
# }

# output "db_host_secondary" {
#    value = linode_database_postgresql.primary.host_secondary
# }

# output "db_username" {
#     value = linode_database_postgresql.primary.root_username
#     sensitive = true
# }

# output "db_password" {
#     value = linode_database_postgresql.primary.root_password
#     sensitive = true
# }