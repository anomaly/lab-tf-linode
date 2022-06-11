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
resource "linode_object_storage_bucket" "bucket_web_client" {
    cluster = data.linode_object_storage_cluster.primary.id
    label = "${var.app_subdomain}.${var.app_tld}"
    acl = "public-read"
}

# The key provisioned will be able to read and write, this is used
# by the s3cmd tool to copy files to it
resource "linode_object_storage_key" "key_bucket_web_client" {
  label = "key_bucket_web_client"
  bucket_access {
    bucket_name = linode_object_storage_bucket.bucket_web_client.label
    cluster     = data.linode_object_storage_cluster.primary.id
    permissions = "read_write"
  }
}

# Uses the kubernetes_secret resource to write the keys to the cluster
# this will allow the application to grab these from the environment
# avoiding the need for a configuration file passing them on
resource "kubernetes_secret" "bucket_credentials_web_client" {
  depends_on = [
    linode_lke_cluster.cluster_k8s,
    linode_object_storage_key.key_bucket_web_client
  ]

  metadata {
     name = "bucket_credentials_web_client"
  }

  data = {
    access_key = "${linode_object_storage_key.key_bucket_web_client.access_key}"
    secret_key = "${ linode_object_storage_key.key_bucket_web_client.secret_key}"
  }
}

# Applicaiton file store bucket
resource "linode_object_storage_bucket" "bucket_file_store" {
    cluster = data.linode_object_storage_cluster.primary.id
    label = "${var.app_subdomain}.${var.app_tld}-filestore"
}

# This key has read and write access and will be used by the 
# application to sign upload and download
resource "linode_object_storage_key" "key_bucket_file_store" {
  label = "key_bucket_file_store"
  bucket_access {
    bucket_name = linode_object_storage_bucket.bucket_file_store.label
    cluster     = data.linode_object_storage_cluster.primary.id
    permissions = "read_write"
  }
}

# Uses the kubernetes_secret resource to write the keys to the cluster
# this will allow the application to grab these from the environment
# avoiding the need for a configuration file passing them on
resource "kubernetes_secret" "bucket_credentials_file_store" {
  depends_on = [
    linode_lke_cluster.cluster_k8s,
    linode_object_storage_key.key_bucket_file_store
  ]

  metadata {
     name = "bucket_credentials_file_store"
  }

  data = {
    access_key = "${linode_object_storage_key.key_bucket_file_store.access_key}"
    secret_key = "${ linode_object_storage_key.key_bucket_file_store.secret_key}"
  }
}
