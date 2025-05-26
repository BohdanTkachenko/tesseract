resource "libvirt_volume" "root" {
  depends_on = [libvirt_ignition.ignition]
  lifecycle {
    replace_triggered_by = [libvirt_ignition.ignition]
  }
  name           = var.hostname
  base_volume_id = var.fcos_volume_id
  pool           = var.pool_name
  size           = var.disk_size_gib * 1024 * 1024 * 1024
}
