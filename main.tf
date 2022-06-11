
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
            version = "~> 1.20"
        }
        # Kubernetes providers to provisiont he application 
        # and other requires services
        helm = {
            source = "hashicorp/helm"
            version = "2.4.1"
        }
        kubernetes = {
            source = "hashicorp/kubernetes"
            version = "2.8.0"     
        }
        kubectl = {
            source = "gavinbunney/kubectl"
            version = "1.13.1"
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
# TODO: can we make the parsing a bit better?
provider "helm" {
    kubernetes {
        host = yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).clusters[0].cluster.server
        cluster_ca_certificate = base64decode(yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).clusters[0].cluster.certificate-authority-data)
        token = yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).users[0].user.token
    }
}

provider "kubernetes" {
    host = yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).clusters[0].cluster.server
    cluster_ca_certificate = base64decode(yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).clusters[0].cluster.certificate-authority-data)
    token = yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).users[0].user.token
}

provider "kubectl" {
    load_config_file = false
    host = yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).clusters[0].cluster.server
    cluster_ca_certificate = base64decode(yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).clusters[0].cluster.certificate-authority-data)
    token = yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).users[0].user.token
}

# This file defines a Kubernetes cluster that will be provisioned
# on linode's infrasrtructure, note that you will have to provide
# the values for your cluster
resource "linode_lke_cluster" "k8s-cluster" {
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
resource "linode_object_storage_bucket" "bucket-web-client" {
    cluster = data.linode_object_storage_cluster.primary.id
    label = "${var.app_subdomain}.${var.app_tld}"
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

# Uses the kubernetes_secret resource to write the keys to the cluster
# this will allow the application to grab these from the environment
# avoiding the need for a configuration file passing them on
resource "kubernetes_secret" "bucket-credentials-web-client" {
  depends_on = [
    linode_lke_cluster.k8s-cluster,
    linode_object_storage_key.key-bucket-web-client
  ]

  metadata {
     name = "bucket-credentials-web-client"
  }

  data = {
    access_key = linode_object_storage_key.key-bucket-web-client.access_key
    secret_key = linode_object_storage_key.key-bucket-web-client.secret_key
  }
}

# Applicaiton file store bucket
resource "linode_object_storage_bucket" "bucket-file-store" {
    cluster = data.linode_object_storage_cluster.primary.id
    label = "${var.app_subdomain}.${var.app_tld}-filestore"
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

# Uses the kubernetes_secret resource to write the keys to the cluster
# this will allow the application to grab these from the environment
# avoiding the need for a configuration file passing them on
resource "kubernetes_secret" "bucket-credentials-file-store" {
  depends_on = [
    linode_lke_cluster.k8s-cluster,
    linode_object_storage_key.key-bucket-file-store
  ]

  metadata {
     name = "bucket-credentials-file-store"
  }

  data = {
    access_key = "${linode_object_storage_key.key-bucket-file-store.access_key}"
    secret_key = "${ linode_object_storage_key.key-bucket-file-store.secret_key}"
  }
}



# Install a high availability postgres database cluster via helm
resource "helm_release" "postgresql" {

    depends_on = [
        linode_lke_cluster.k8s-cluster
    ]

    name = "postgresql"

    repository = "https://charts.bitnami.com/bitnami"
    chart = "postgresql"

    set {
      name  = "replicaCount"
      value = 1
    }

}

resource "helm_release" "redis" {
    depends_on = [
        linode_lke_cluster.k8s-cluster
    ]

    name = "redis"
    repository = "https://charts.bitnami.com/bitnami"
    chart = "redis"

    set {
        name  = "cluster.enabled"
        value = "true"
    }

    set {
        name  = "metrics.enabled"
        value = "true"
    }
}

resource "helm_release" "traefik" {
    depends_on = [
         linode_lke_cluster.k8s-cluster
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
    
    # Default Redirect
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