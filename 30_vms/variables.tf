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
}

variable "fcos" {
  type = object({
    stream_url   = string
    architecture = string
    platform     = string
    format       = string
    local_dir    = string
  })
}

variable "k8s" {
  type = object({
    version = string
    ca_path = string
  })
}

variable "wireguard" {
  type = map(object({
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
  }))
}

variable "kubernetes_config_path" {
  type = string
}
