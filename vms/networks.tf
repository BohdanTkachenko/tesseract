resource "libvirt_network" "main" {
  name      = "main"
  mode      = "nat"
  addresses = ["10.42.123.0/24"]
}
