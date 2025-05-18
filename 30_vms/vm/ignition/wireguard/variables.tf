variable "wireguard" {
  type = object({
    if_name     = string
    public_key  = string
    private_key = string
    vpn_host    = string
    vpn_port    = number
    vpn_net     = string
    lan_net     = string
  })
}
