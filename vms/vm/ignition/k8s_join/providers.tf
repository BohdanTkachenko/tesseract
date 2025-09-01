terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }

    ignition = {
      source  = "community-terraform-providers/ignition"
      version = "2.5.1"
    }

    shell = {
      source  = "scottwinkler/shell"
      version = "1.7.10"
    }
  }
}
