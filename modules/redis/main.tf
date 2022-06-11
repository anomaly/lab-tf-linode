# Install a redis instance using Helm on the client
resource "helm_release" "redis" {
    depends_on = [
        linode_lke_cluster.cluster_k8s
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