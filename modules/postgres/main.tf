# Install a high availability postgres database cluster via helm
resource "helm_release" "postgresql" {

    depends_on = [
        linode_lke_cluster.cluster_k8s
    ]

    name = "postgresql"

    repository = "https://charts.bitnami.com/bitnami"
    chart = "postgresql"

    set {
      name  = "replicaCount"
      value = 1
    }

}
