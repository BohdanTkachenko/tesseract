data "ignition_file" "wanted_packages" {
  path = "/etc/rpm/packages.wants/qemu"
  contents {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(
      join("\n", [
        "selinux-policy-devel",
        "qemu-guest-agent"
      ])
    )}"
  }
}
