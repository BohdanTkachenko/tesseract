variable "ssh" {
  description = "Main node SSH connection details."
  sensitive   = true
  type = object({
    agent               = bool
    host                = string
    port                = number
    user                = string
    password            = string
    private_key         = string
    bastion_host        = string
    bastion_port        = number
    bastion_user        = string
    bastion_password    = string
    bastion_private_key = string
  })
  default = {
    agent               = false
    host                = "tesseract.lan"
    port                = 22
    user                = "terraform"
    password            = null
    private_key         = "~/.ssh/terraform"
    bastion_host        = null
    bastion_port        = null
    bastion_user        = null
    bastion_password    = null
    bastion_private_key = null
  }
}

variable "node_name" {
  type    = string
  default = "tesseract.sh"
}

variable "remote_clusterconfig_path" {
  type    = string
  default = "/var/lib/terraform/kubernetes-clusterconfig.yaml"
}

