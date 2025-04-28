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

    ct = {
      source  = "poseidon/ct"
      version = "0.13.0"
    }
  }
}

provider "http" {}

provider "shell" {}

provider "libvirt" {
  uri = "qemu+ssh://${var.ssh.user}@${var.ssh.host}:${var.ssh.port}/system?keyfile=${var.ssh.private_key}"
}

provider "ct" {}
