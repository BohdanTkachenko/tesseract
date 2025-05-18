data "ignition_config" "config" {
  files   = [data.ignition_file.join_config.rendered]
  systemd = [data.ignition_systemd_unit.k8s_join_cluster.rendered]
}

output "hash" {
  value = sha256(data.ignition_config.config.rendered)
}

output "config" {
  value = jsondecode(data.ignition_config.config.rendered)
}
