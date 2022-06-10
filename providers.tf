
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
        host = "${yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).clusters[0].cluster.server}"
        cluster_ca_certificate ="${base64decode(yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).clusters[0].cluster.certificate-authority-data)}"
        token = "${yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).users[0].user.token}"
    }
}

provider "kubernetes" {
    host = "${yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).clusters[0].cluster.server}"
    cluster_ca_certificate ="${base64decode(yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).clusters[0].cluster.certificate-authority-data)}"
    token = "${yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).users[0].user.token}"
}

provider "kubectl" {
    load_config_file = false
    host = "${yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).clusters[0].cluster.server}"
    cluster_ca_certificate ="${base64decode(yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).clusters[0].cluster.certificate-authority-data)}"
    token = "${yamldecode(base64decode(linode_lke_cluster.k8s-cluster.kubeconfig)).users[0].user.token}"
}