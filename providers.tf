
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
provider "helm" {
    kubernetes {
        host = "${yamldecode(linode_lke_cluster.k8s-cluster.kubeconfig).clusters.0.cluster.server}"
        client_certificate = "${base64decode(yamldecode(linode_lke_cluster.k8s-cluster.kubeconfig).users.0.user.client-certificate-data)}"
        client_key = "${base64decode(yamldecode(linode_lke_cluster.k8s-cluster.kubeconfig).users.0.user.client-key-data)}"
        cluster_ca_certificate ="${base64decode(yamldecode(linode_lke_cluster.k8s-cluster.kubeconfig).clusters.0.cluster.certificate-authority-data)}"
    }
}

provider "kubernetes" {
    host = "${yamldecode(linode_lke_cluster.k8s-cluster.kubeconfig).clusters.0.cluster.server}"
    client_certificate = "${base64decode(yamldecode(linode_lke_cluster.k8s-cluster.kubeconfig).users.0.user.client-certificate-data)}"
    client_key = "${base64decode(yamldecode(linode_lke_cluster.k8s-cluster.kubeconfig).users.0.user.client-key-data)}"
    cluster_ca_certificate = "${base64decode(yamldecode(linode_lke_cluster.k8s-cluster.kubeconfig).clusters.0.cluster.certificate-authority-data)}"
}

provider "kubectl" {
    host = "${yamldecode(linode_lke_cluster.k8s-cluster.kubeconfig).clusters.0.cluster.server}"
    client_certificate = "${base64decode(yamldecode(linode_lke_cluster.k8s-cluster.kubeconfig).users.0.user.client-certificate-data)}"
    client_key = "${base64decode(yamldecode(linode_lke_cluster.k8s-cluster.kubeconfig).users.0.user.client-key-data)}"
    cluster_ca_certificate = "${base64decode(yamldecode(linode_lke_cluster.k8s-cluster.kubeconfig).clusters.0.cluster.certificate-authority-data)}"
    load_config_file = false
}