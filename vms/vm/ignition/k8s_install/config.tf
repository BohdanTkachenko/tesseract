data "ignition_file" "sysctl_kubernetes" {
  path = "/etc/sysctl.d/kubernetes.conf"
  contents {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(
      file("${path.module}/contents/files/etc/sysctl.d/kubernetes.conf")
    )}"
  }
}
