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

    ssh = {
      source  = "loafoe/ssh"
      version = "2.7.0"
    }

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
  }
}

provider "http" {}

provider "shell" {}

provider "libvirt" {
  uri = "qemu+ssh://${var.ssh.user}@${var.ssh.host}:${var.ssh.port}/system?keyfile=${var.ssh.private_key}"
}

provider "ignition" {}

provider "ssh" {}

provider "kubernetes" {
  config_path = var.kubernetes_config_path
}
