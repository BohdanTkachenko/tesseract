data "ignition_systemd_unit" "wireguard" {
  name    = "wg-quick@${var.wireguard.if_name}.service"
  enabled = true
}
