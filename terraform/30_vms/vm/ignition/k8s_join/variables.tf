variable "triggers" {
  type = list(string)
}

variable "hostname" {
  type = string
}

variable "server" {
  type = string
}

variable "ca_hash" {
  type      = string
  sensitive = true
}

variable "ssh" {
  sensitive = true
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
}
