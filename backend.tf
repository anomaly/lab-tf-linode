

provider "linode" {
  token = var.linode_token
}

terraform {
	
    organisation = "{{.Organisation}}"
	
    workspaces {
		prefix = "tf-project-"
	}

	backend "remote" {
		
	}

    required_providers {
        linode = {
            source  = "linode/linode"
            version = "~> 1.20"
        }
    }
}
