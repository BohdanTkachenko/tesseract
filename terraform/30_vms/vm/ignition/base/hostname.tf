data "ignition_file" "hostname" {
  path = "/etc/hostname"
  mode = 420
  contents {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(var.hostname)}"
  }
}
