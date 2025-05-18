data "ignition_systemd_unit" "autologin" {
  name = "serial-getty@ttyS0.service"
  dropin {
    name    = "autologin-core.conf"
    content = file("${path.module}/contents/systemd/autologin-core.conf")
  }
}
