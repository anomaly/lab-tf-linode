# The web client secrets will be used to copy files into the
# bucket when we release a new version of the application
output "key_accesss_bucket_web_client" {
    value = linode_object_storage_key.key_bucket_web_client.access_key
    sensitive = true
}

output "key_secret_bucket_web_client" {
    value = linode_object_storage_key.key_bucket_web_client.secret_key
    sensitive = true
}

# Outputs the access and secret key for both buckets
# these are required by the application to store and retrieve files
output "key_accesss_bucket_file_store" {
    value = linode_object_storage_key.key_bucket_file_store.access_key
    sensitive = true
}

output "key_secret_bucket_file_store" {
    value = linode_object_storage_key.key_bucket_file_store.secret_key
    sensitive = true
}