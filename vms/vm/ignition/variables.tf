variable "hostname" {
  type = string
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

variable "fcos_version" {
  type = number
}

variable "nvidia" {
  type = bool
}

variable "k8s" {
  type = object({
    version = string
    server  = string
    ca_hash = string
  })
  nullable = true
}

variable "mounts" {
  type = map(string)
}

variable "wireguard" {
  type = object({
    vpn_country   = string
    vpn_city      = string
    vpn_p2p       = bool
    vpn_private   = bool
    vpn_tor       = bool
    vpn_streaming = bool
    if_name       = string
    public_key    = string
    private_key   = string
    vpn_host      = string
    vpn_port      = number
    vpn_net       = string
    lan_net       = string
  })
  nullable = true
}

