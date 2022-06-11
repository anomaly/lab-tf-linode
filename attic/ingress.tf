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