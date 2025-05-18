data "ignition_config" "config" {
  systemd = [
    for unit in data.ignition_systemd_unit.mount : unit.rendered
  ]
}

output "hash" {
  value = sha256(data.ignition_config.config.rendered)
}

output "config" {
  value = jsondecode(data.ignition_config.config.rendered)
}
