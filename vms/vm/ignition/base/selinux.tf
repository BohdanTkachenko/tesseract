locals {
  selinux_policy_te = <<-EOT
    module virtiofs_volumes 1.0;
    require {
      type container_t;
      type virtiofs_t;
      class dir { create search read write open getattr setattr add_name remove_name unlink };
      class file { create read write open getattr setattr };
    }

    # Allow containers to access the default virtiofs type with full permissions
    allow container_t virtiofs_t:dir { create search read write open getattr setattr add_name remove_name unlink };
    allow container_t virtiofs_t:file { create read write open getattr setattr };
  EOT
}

data "ignition_file" "selinux_policy_te" {
  path = "/etc/selinux/virtiofs_volumes.te"
  mode = "0644"
  contents {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(
      local.selinux_policy_te
    )}"
  }
}

data "ignition_systemd_unit" "selinux_policy_install" {
  name    = "selinux-virtiofs-policy.service"
  enabled = true
  content = <<-EOT
    [Unit]
    Description=Install SELinux policy for virtiofs mounts
    DefaultDependencies=no
    After=network-online.target rpm-ostree-install-wanted-packages.service
    Before=kubelet.service
    ConditionPathExists=/usr/bin/checkmodule

    [Service]
    Type=oneshot
    ExecStart=/bin/sh -c "checkmodule -M -m -o /etc/selinux/virtiofs_volumes.mod /etc/selinux/virtiofs_volumes.te && semodule_package -o /etc/selinux/virtiofs_volumes.pp -m /etc/selinux/virtiofs_volumes.mod && semodule -i /etc/selinux/virtiofs_volumes.pp"
    RemainAfterExit=yes

    [Install]
    WantedBy=multi-user.target
  EOT
}
