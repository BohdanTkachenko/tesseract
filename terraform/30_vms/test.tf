resource "libvirt_volume" "test01" {
  depends_on     = [libvirt_volume.fcos]
  name           = "test01"
  base_volume_id = libvirt_volume.fcos.id
  pool           = libvirt_pool.default.name
  size           = "34359738368" # 32 GiB
}

data "ct_config" "test01" {
  content = templatefile("${path.module}/butane/test01.bu", {
    password_hash = var.core_password
  })
  strict       = true
  pretty_print = true
}

resource "libvirt_ignition" "test01" {
  name    = "test01.ign"
  pool    = libvirt_pool.default.name
  content = data.ct_config.test01.rendered
}

resource "libvirt_domain" "test01" {
  name            = "test01"
  coreos_ignition = libvirt_ignition.test01.id

  vcpu   = "2"
  memory = "8192" # 8 GiB
  disk {
    volume_id = libvirt_volume.test01.id
  }

  console {
    type        = "pty"
    target_port = 0
  }

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    network_name = libvirt_network.default.name
  }
}
