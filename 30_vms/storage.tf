resource "libvirt_pool" "main" {
  name = "main"
  type = "dir"
  target {
    path = "/var/lib/virt/images"
  }
}
