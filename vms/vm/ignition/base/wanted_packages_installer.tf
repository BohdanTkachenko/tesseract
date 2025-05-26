data "ignition_file" "rpm_ostree_install_wanted_packages" {
  path = "/var/usrlocal/bin/rpm-ostree-install-wanted-packages.sh"
  mode = 448
  contents {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(
      file("${path.module}/contents/files/var/usrlocal/bin/rpm-ostree-install-wanted-packages.sh")
    )}"
  }
}

data "ignition_systemd_unit" "rpm_ostree_install_wanted_packages" {
  name    = "rpm-ostree-install-wanted-packages.service"
  content = file("${path.module}/contents/systemd/rpm-ostree-install-wanted-packages.service")
}
