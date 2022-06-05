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


    # Use terraform cloud as our backend for state and secret
    # management, this will enable collaboration and sharing
    # the state of the application
    # backend "remote" {
        
    # }

}
