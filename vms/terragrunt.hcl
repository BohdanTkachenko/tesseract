dependency "service_account" {
  config_path = "${get_terragrunt_dir()}/../service_account"
}

dependency "metal" {
  config_path = "${get_terragrunt_dir()}/../metal"
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("config.hcl")).inputs
}

inputs = {
  libvirt_ssh_connection_string = dependency.service_account.outputs.libvirt_ssh_connection_string
  ssh                           = dependency.service_account.outputs.ssh_config
  fcos                          = local.config.vm_base_fcos_image_remote
  k8s = {
    version = local.config.k8s.version
    ca_hash = dependency.metal.outputs.k8s_certificate_authority_hash
    server  = dependency.metal.outputs.k8s_server
  }
  kube_config_path = dependency.metal.outputs.kube_config_path
  vms              = local.config.vms
}