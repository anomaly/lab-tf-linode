
data "linode_object_storage_cluster" "primary" {
    id = var.object_store_cluster_id
}