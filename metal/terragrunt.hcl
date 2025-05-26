dependency "service_account" {
  config_path = "${get_terragrunt_dir()}/../service_account"
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("config.hcl")).inputs
}

inputs = {
  node_name                    = local.config.host.hostname
  api_server                   = local.config.k8s.api_server
  nameserver                   = local.config.host.network.nameserver
  remote_kubeconfig_path       = local.config.k8s.remote.kubeconfig_path
  remote_admin_kubeconfig_path = local.config.k8s.remote.admin_kubeconfig_path
  remote_clusterconfig_path    = local.config.k8s.remote.clusterconfig_path
  remote_ca_path               = local.config.k8s.remote.ca_path
  remote_resolv_conf_path      = local.config.k8s.remote.resolv_conf_path
  local_ca_path                = local.config.k8s.local.ca_path
  local_key_path               = local.config.k8s.local.key_path
  local_csr_path               = local.config.k8s.local.csr_path
  local_crt_path               = local.config.k8s.local.crt_path
  local_kubeconfig_path        = local.config.k8s.local.kubeconfig_path
  ssh                          = dependency.service_account.outputs.ssh_config
}