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

variable "fcos" {
  type = object({
    stream_url   = string
    architecture = string
    platform     = string
    format       = string
    local_dir    = string
  })
  default = {
    stream_url   = "https://builds.coreos.fedoraproject.org/streams/stable.json"
    architecture = "x86_64"
    platform     = "qemu"
    format       = "qcow2.xz"
    local_dir    = "/tmp"
  }
}

variable "k8s" {
  type = object({
    version = string
    ca_path = string
  })
  default = {
    version = "1.32"
    ca_path = "~/.kube/ca.crt"
  }
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
  type    = string
  default = "~/.kube/config"
}
