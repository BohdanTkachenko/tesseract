terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.3"
    }

    ignition = {
      source  = "community-terraform-providers/ignition"
      version = "2.5.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }

    shell = {
      source  = "scottwinkler/shell"
      version = "1.7.10"
    }
  }
}
