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