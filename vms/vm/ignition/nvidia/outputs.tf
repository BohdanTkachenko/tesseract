data "ignition_config" "config" {
  files = [
    data.ignition_file.wanted_packages.rendered,
  ]
  systemd = [
    data.ignition_systemd_unit.rpm_ostree_install_nvidia.rendered,
  ]
}

output "hash" {
  value = sha256(data.ignition_config.config.rendered)
}

output "config" {
  value = jsondecode(data.ignition_config.config.rendered)
}
