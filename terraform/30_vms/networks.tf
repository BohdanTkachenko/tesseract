resource "libvirt_network" "default" {
  name      = "default"
  mode      = "nat"
  addresses = ["10.42.123.0/24"]
}
