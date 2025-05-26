terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.3"
    }

    ssh = {
      source  = "loafoe/ssh"
      version = "2.7.0"
    }

    ignition = {
      source  = "community-terraform-providers/ignition"
      version = "2.5.1"
    }
  }
}
