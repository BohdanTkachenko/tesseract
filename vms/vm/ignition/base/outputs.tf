data "ignition_config" "config" {
  files = [
    data.ignition_file.hostname.rendered,
    data.ignition_file.systemd_pager.rendered,
    data.ignition_file.wanted_packages.rendered,
    data.ignition_file.rpm_ostree_install_wanted_packages.rendered,
  ]

  systemd = [
    data.ignition_systemd_unit.autologin.rendered,
    data.ignition_systemd_unit.rpm_ostree_install_wanted_packages.rendered,
  ]
}

output "hash" {
  value = sha256(data.ignition_config.config.rendered)
}

output "config" {
  value = jsondecode(data.ignition_config.config.rendered)
}
