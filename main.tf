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
    }

    # Use terraform cloud as our backend for state and secret
    # management, this will enable collaboration and sharing
    # the state of the application
    # backend "remote" {
        
    # }

}
