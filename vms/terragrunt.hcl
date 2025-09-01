include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("config.hcl")).inputs
}

inputs = {
  libvirt_connection_string = local.config.libvirt_connection_string
  fcos                      = local.config.vm_base_fcos_image_remote
  k8s = {
    version = local.config.k8s.version
    ca_path = local.config.k8s.local.ca_path
  }
  kube_config_path = local.config.k8s.local.kubeconfig_path
  vms              = local.config.vms
}
