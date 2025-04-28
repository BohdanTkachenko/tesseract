resource "libvirt_pool" "default" {
  name = "default"
  type = "dir"
  target {
    path = "/var/lib/virt/images"
  }
}
