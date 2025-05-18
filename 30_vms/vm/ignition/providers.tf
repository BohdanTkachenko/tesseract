terraform {
  required_providers {
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
