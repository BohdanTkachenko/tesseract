terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "3.5.0"
    }

    shell = {
      source  = "scottwinkler/shell"
      version = "1.7.10"
    }

    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}
