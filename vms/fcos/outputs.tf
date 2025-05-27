output "volume_id" {
  value = libvirt_volume.fcos.id
}

output "version" {
  value = var.fcos.version
}
