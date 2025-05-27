data "ignition_file" "wanted_packages" {
  path = "/etc/rpm/packages.wants/rpm-fusion"
  contents {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(
      join("\n", [
        "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${var.fcos_version}.noarch.rpm"
      ])
    )}"
  }
}

data "ignition_systemd_unit" "rpm_ostree_install_nvidia" {
  name    = "rpm-ostree-install-nvidia.service"
  content = file("${path.module}/contents/systemd/rpm-ostree-install-nvidia.service")
}
