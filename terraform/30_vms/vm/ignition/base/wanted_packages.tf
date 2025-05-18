data "ignition_file" "wanted_package_qemu_guest_agent" {
  path = "/etc/rpm/packages.wants/qemu-guest-agent"
  contents {
    source = "data:,"
  }
}
