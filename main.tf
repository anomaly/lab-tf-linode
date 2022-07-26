# main.cf - where the majority of the definitions live
#
# It's important to note that terraform will combine all the
# .tf files before execution, the distribution of code between
# these files is purely logical
terraform {

    # We use the Linode provider to speak with their v4 API
    # subsequently we will use the Kubernetes provider to
    # provision applications into the cluster
    required_providers {
        linode = {
            source  = "linode/linode"
            version = "1.28"
        }
        # Kubernetes providers to provisiont he application 
        # and other requires services
        helm = {
            source = "hashicorp/helm"
            version = "2.5.1"
        }
        kubernetes = {
            source = "hashicorp/kubernetes"
            version = "2.11.0"     
        }
        kubectl = {
            source = "gavinbunney/kubectl"
            version = "1.14.0"
        }

    }
    
}

# The Linode provider requires an API token that you can
# generate using the linode-cli (check README)
# https://registry.terraform.io/providers/linode/linode/latest/docs
#
# This is ultimately stored in Terraform cloud
provider "linode" {
    token = var.linode_token
}

# For the following providers we load the values from the secrets
# that the Linode Kubernetes resource will provide for us.
#
# The kubectl configuration which is available via the output
# terraform output kubeconfig 
# is a base64 encoded yaml file, which will be decoded and parsed
#
# Linode uses the host, cluster_ca_certificate, and token to talk
# back to the cluster
provider "helm" {
    kubernetes {
        host = yamldecode(base64decode(linode_lke_cluster.primary.kubeconfig)).clusters[0].cluster.server
        cluster_ca_certificate = base64decode(yamldecode(base64decode(linode_lke_cluster.primary.kubeconfig)).clusters[0].cluster.certificate-authority-data)
        token = yamldecode(base64decode(linode_lke_cluster.primary.kubeconfig)).users[0].user.token
    }
}

provider "kubernetes" {
    host = yamldecode(base64decode(linode_lke_cluster.primary.kubeconfig)).clusters[0].cluster.server
    cluster_ca_certificate = base64decode(yamldecode(base64decode(linode_lke_cluster.primary.kubeconfig)).clusters[0].cluster.certificate-authority-data)
    token = yamldecode(base64decode(linode_lke_cluster.primary.kubeconfig)).users[0].user.token
}

provider "kubectl" {
    load_config_file = false
    host = yamldecode(base64decode(linode_lke_cluster.primary.kubeconfig)).clusters[0].cluster.server
    cluster_ca_certificate = base64decode(yamldecode(base64decode(linode_lke_cluster.primary.kubeconfig)).clusters[0].cluster.certificate-authority-data)
    token = yamldecode(base64decode(linode_lke_cluster.primary.kubeconfig)).users[0].user.token
}

# This file defines a Kubernetes cluster that will be provisioned
# on linode's infrasrtructure, note that you will have to provide
# the values for your cluster
resource "linode_lke_cluster" "primary" {
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
resource "linode_object_storage_bucket" "web_client" {
    cluster = data.linode_object_storage_cluster.primary.id
    label = "${var.app_subdomain}.${var.app_tld}"
    acl = "public-read"
}

# The key provisioned will be able to read and write, this is used
# by the s3cmd tool to copy files to it
resource "linode_object_storage_key" "web_client" {
  label = "key_bucket_web_client"
  bucket_access {
    bucket_name = linode_object_storage_bucket.web_client.label
    cluster     = data.linode_object_storage_cluster.primary.id
    permissions = "read_write"
  }
}

# Uses the kubernetes_secret resource to write the keys to the cluster
# this will allow the application to grab these from the environment
# avoiding the need for a configuration file passing them on
resource "kubernetes_secret" "web_client" {
  depends_on = [
    linode_lke_cluster.primary,
    linode_object_storage_bucket.web_client,
    linode_object_storage_key.web_client
  ]

  metadata {
     name = "web-client"
  }

  data = {
    bucket_name = linode_object_storage_bucket.web_client.label
    cluster = linode_object_storage_bucket.web_client.cluster
    fqdn = "${linode_object_storage_bucket.web_client.label}.${linode_object_storage_bucket.web_client.cluster}.linodeobjects.com"
    access_key = linode_object_storage_key.web_client.access_key
    secret_key = linode_object_storage_key.web_client.secret_key
  }
}

# Applicaiton file store bucket
resource "linode_object_storage_bucket" "file_store" {
    cluster = data.linode_object_storage_cluster.primary.id
    label = "${var.app_subdomain}.${var.app_tld}-filestore"
}

# This key has read and write access and will be used by the 
# application to sign upload and download
resource "linode_object_storage_key" "file_store" {
  label = "key_bucket_file_store"
  bucket_access {
    bucket_name = linode_object_storage_bucket.file_store.label
    cluster     = data.linode_object_storage_cluster.primary.id
    permissions = "read_write"
  }
}

# Uses the kubernetes_secret resource to write the keys to the cluster
# this will allow the application to grab these from the environment
# avoiding the need for a configuration file passing them on
resource "kubernetes_secret" "file_store" {
  depends_on = [
    linode_lke_cluster.primary,
    linode_object_storage_bucket.file_store,
    linode_object_storage_key.file_store
  ]

  metadata {
     name = "file-store"
  }

  data = {
    bucket_name = linode_object_storage_bucket.file_store.label
    cluster = linode_object_storage_bucket.file_store.cluster
    fqdn = "${linode_object_storage_bucket.file_store.label}.${linode_object_storage_bucket.file_store.cluster}.linodeobjects.com"
    access_key = linode_object_storage_key.file_store.access_key
    secret_key = linode_object_storage_key.file_store.secret_key
  }
}

# Provisions a managed PostgresSQL cluster on Linode's infrasrtructure
# The cluster can be varied from a single node through to as many as
# we desire.
# resource "linode_database_postgresql" "primary" {

#   depends_on = [
#     linode_lke_cluster.primary,
#   ]

#     label = "primary_db"

#     engine_id = "postgresql/13.2"
#     region = var.db_region
#     type = var.db_node_type
#     cluster_size = var.db_cluster_size

#     encrypted = true
#     replication_type = "semi_synch"
#     replication_commit_type = "remote_write"
#     ssl_connection = true

#     updates {
#         day_of_week = "saturday"
#         duration = 1
#         frequency = "monthly"
#         hour_of_day = 22
#         week_of_month = 2
#     }
# }

# Write the relevant secrets to the Kubernetes cluster so the application
# can read this from the environment variables
# resource "kubernetes_secret" "db_primary" {
#   depends_on = [
#     linode_database_postgresql.primary
#   ]

#   metadata {
#      name = "primary-db"
#   }

#   data = {
#     root_password = linode_database_postgresql.primary.root_password
#     root_username = linode_database_postgresql.primary.root_username
#     host_primary = linode_database_postgresql.primary.host_primary
#     host_secondary = linode_database_postgresql.primary.host_secondary
#     ca_cert = linode_database_postgresql.primary.ca_cert
#   }
# }

# Install a high availability postgres database cluster via helm
# Note: helm releases write their secrets to the kubernetes cluster
# resource "helm_release" "postgresql" {

#     depends_on = [
#         linode_lke_cluster.primary
#     ]

#     name = "postgresql"

#     repository = "https://charts.bitnami.com/bitnami"
#     chart = "postgresql"

#     set {
#       name  = "replicaCount"
#       value = 1
#     }

# }

# resource "helm_release" "redis" {
#     depends_on = [
#         linode_lke_cluster.primary,
#         helm_release.postgresql
#     ]

#     name = "redis"
#     repository = "https://charts.bitnami.com/bitnami"
#     chart = "redis"

#     set {
#         name  = "cluster.enabled"
#         value = "true"
#     }

#     set {
#         name  = "metrics.enabled"
#         value = "true"
#     }
# }

# This will provision a nodebalancer and traefik  to serve the
# application
resource "helm_release" "traefik" {
    depends_on = [
        linode_lke_cluster.primary,
        # helm_release.redis,
        # helm_release.postgresql 
    ]

    name = "traefik"
    repository = "https://helm.traefik.io/traefik"
    chart = "traefik"

    # Set Traefik as the Default Ingress Controller
    set {
        name  = "ingressClass.enabled"
        value = "true"
    }
    set {
        name  = "ingressClass.isDefaultClass"
        value = "true"
    }
    
    # Default Redirect HTTP to HTTPS
    set {
        name  = "ports.web.redirectTo"
        value = "websecure"
    }

    # Enable TLS on Websecure
    set {
        name  = "ports.websecure.tls.enabled"
        value = "true"
    }
}

