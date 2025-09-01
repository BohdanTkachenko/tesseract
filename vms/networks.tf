resource "libvirt_network" "main" {
  name      = "main"
  mode      = "nat"
  autostart = true
  addresses = ["10.42.123.0/24"]
}
