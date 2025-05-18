output "config" {
  value = jsondecode(data.ignition_config.merged.rendered)
}
