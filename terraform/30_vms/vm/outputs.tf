output "ipv4" {
  value = libvirt_domain.domain.network_interface.0.addresses
}
