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
resource "linode_object_storage_bucket" "bucket-web-client" {
    cluster = data.linode_object_storage_cluster.primary.id
    label = "app.mylabs.com"
}

# Applicaiton file store bucket
resource "linode_object_storage_bucket" "bucket-file-store" {
    cluster = data.linode_object_storage_cluster.primary.id
    label = "app-filestore"
}