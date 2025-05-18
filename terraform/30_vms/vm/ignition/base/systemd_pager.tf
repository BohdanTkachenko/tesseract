data "ignition_file" "systemd_pager" {
  path = "/etc/profile.d/systemd-pager.sh"
  mode = 420
  contents {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(
      file("${path.module}/contents/files/etc/profile.d/systemd-pager.sh")
    )}"
  }
}
