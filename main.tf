# main.cf - where the majority of the definitions live
#
# It's important to note that terraform will combine all the
# .tf files before execution, the distribution of code between
# these files is purely logical
# 
# We divided the infrarstructure into modules as recommended 
# bu Terraform docs.
terraform {
    # We use the Linode provider to speak with their v4 API
    # subsequently we will use the Kubernetes provider to
    # provision applications into the cluster
    required_providers {
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

# Load modules as required by this setup, our top level setup
# provisions everything inside of a k8s cluster (other samples)
# provide setup for production/staging evnvironments

module "k8s" {
    source = "./modules/k8s"

    linode_token = var.linode_token

    k8s_label = var.k8s_label
    k8s_version = var.k8s_version
    k8s_region = var.k8s_region
    k8s_tags = var.k8s_tags
}

module "objectstore" {
    source = "./modules/objectstore"
    linode_token = var.linode_token

    app_tld = var.app_tld
    app_subdomain = var.app_subdomain
}