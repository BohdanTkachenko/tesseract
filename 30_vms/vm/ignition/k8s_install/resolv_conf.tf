data "ignition_link" "resolv_conf" {
  path   = "/etc/resolv.kubelet.conf"
  target = "/etc/resolv.conf"
}
