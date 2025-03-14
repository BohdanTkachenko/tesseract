terraform {
  required_providers {
    shell = {
      source  = "scottwinkler/shell"
      version = "1.7.10"
    }

    ssh = {
      source  = "loafoe/ssh"
      version = "2.7.0"
    }
  }
}

provider "shell" {}

provider "ssh" {
  debug_log = "/tmp/terraform-ssh.log"
}
