resource "libvirt_domain" "domain" {
  depends_on = [
    ssh_sensitive_resource.create_host_storage_dir,
    libvirt_volume.root,
    libvirt_ignition.ignition,
  ]

  name            = var.hostname
  coreos_ignition = libvirt_ignition.ignition.id
  autostart       = true
  qemu_agent      = true
  vcpu            = var.vcpu
  memory          = var.memory_mb

  disk {
    volume_id = libvirt_volume.root.id
  }

  console {
    type        = "pty"
    target_port = 0
  }

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    network_name   = var.network_name
    wait_for_lease = true
  }

  xml {
    xslt = templatefile("${path.module}/libvirt.tpl.xsl", {
      host_devices = var.host_devices
    })
  }

  dynamic "filesystem" {
    for_each = local.mounts
    content {
      source     = filesystem.value
      target     = filesystem.key
      accessmode = "passthrough"
      readonly   = false
    }
  }
}
