data "ignition_file" "wireguard_config" {
  path = "/etc/wireguard/${var.wireguard.if_name}.conf"
  mode = 320
  contents {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(
      templatefile("${path.module}/contents/files/etc/wireguard/wg.conf", {
        if_name     = var.wireguard.if_name,
        public_key  = var.wireguard.public_key,
        private_key = var.wireguard.private_key,
        vpn_host    = var.wireguard.vpn_host,
        vpn_port    = var.wireguard.vpn_port,
        vpn_net     = var.wireguard.vpn_net,
        lan_net     = var.wireguard.lan_net,
      })
    )}"
  }
}
