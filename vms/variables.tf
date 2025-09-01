variable "libvirt_connection_string" {
  sensitive = true
}

variable "fcos" {
  type = object({
    version      = number
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

variable "kube_config_path" {
  type = string
}

variable "vms" {
  type = map(object({
    labels        = map(string)
    vcpu          = number
    memory_mb     = number
    disk_size_gib = number
    nvidia        = bool
    host_devices = list(object({
      source_bus   = string
      source_slot  = string
      address_bus  = string
      address_slot = string
    }))
    mounts = list(string)
    wireguard = object({
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
  }))
}
