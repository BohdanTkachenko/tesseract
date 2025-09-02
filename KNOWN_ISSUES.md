# Known Issues

This is a list of things that do not work perfectly, but they are known issues and overall do not block the workflow.

## Custom dmacvicar/libvirt binary is needed

There is a bug in dmacvicar/libvirt which causes the provider to stuck when using cert-based access to libvirt. This is a known issue and it was reported in https://github.com/dmacvicar/terraform-provider-libvirt/issues/1155

There is also a pending PR that fixes the bug: https://github.com/dmacvicar/terraform-provider-libvirt/pull/1166

However, this PR is still pending since March 2025 and is not released yet and therefore not available by default.

As a workaround, I have an ansible role `metal/roles/local_libvirt_workaround` that compiles a binary and creates `metal/roles/local_libvirt_workaround/.terraformrc` file that forces terraform to use this patched binary. When using terraform for `vms` folder this config must be applied. Makefile does it automatically, so no extra work is needed when using a Makefile. However if running Terragrunt/Terraform/OpenTofu manually `TF_CLI_CONFIG_FILE` env must be provided and point to `metal/roles/local_libvirt_workaround/.terraformrc` as an absolute path.

## Terragrunt will apply changes in `vms` directory even if no changes were made

This happens because we generate a fresh random join token and id every time we run. This logic is in `vms/vm/ignition/k8s_join/config.tf`. This is needed for a better security, so this token is only valid for 1 hour. Need to figure out a good way to fix this.
