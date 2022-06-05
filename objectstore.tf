# This configuration provisions object store buckets in Linode's
# infrastructure for the application to either store files 
# and a separate bucket to serve the web client from.
#
# Losely based around Linode's examples
# https://registry.terraform.io/providers/linode/linode/latest/docs/resources/object_storage_bucket

# Definition of where we are going to store our buckets
data "linode_object_storage_cluster" "primary" {
    id = var.object_store_cluster_id
}

# Web client bucket
# Note that the ACL allows public read for the contents of the bucket
# to be reverse proxied in the final setup
resource "linode_object_storage_bucket" "bucket-web-client" {
    cluster = data.linode_object_storage_cluster.primary.id
    label = "app.mylabs.com"
    acl = "public-read"
}

# The key provisioned will be able to read and write, this is used
# by the s3cmd tool to copy files to it
resource "linode_object_storage_key" "key-bucket-web-client" {
  label = "key_bucket_web_client"
  bucket_access {
    bucket_name = linode_object_storage_bucket.bucket-web-client.label
    cluster     = data.linode_object_storage_cluster.primary.id
    permissions = "read_write"
  }
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

# Applicaiton file store bucket
resource "linode_object_storage_bucket" "bucket-file-store" {
    cluster = data.linode_object_storage_cluster.primary.id
    label = "app-filestore"
}

# This key has read and write access and will be used by the 
# application to sign upload and download
resource "linode_object_storage_key" "key-bucket-file-store" {
  label = "key_bucket_file_store"
  bucket_access {
    bucket_name = linode_object_storage_bucket.bucket-file-store.label
    cluster     = data.linode_object_storage_cluster.primary.id
    permissions = "read_write"
  }
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