data "ignition_config" "config" {
  files = [
    data.ignition_file.wireguard_config.rendered,
  ]

  systemd = [
    data.ignition_systemd_unit.wireguard.rendered,
  ]
}

output "hash" {
  value = sha256(data.ignition_config.config.rendered)
}

output "config" {
  value = jsondecode(data.ignition_config.config.rendered)
}
