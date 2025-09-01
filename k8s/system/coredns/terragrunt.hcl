include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "cilium" {
  config_path = "${get_terragrunt_dir()}/../cilium"
  mock_outputs = {
    gateway_namespace = ""
    gateway_name      = ""
  }
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("config.hcl")).inputs
}

inputs = {
  kube_config_path = local.config.k8s.local.kubeconfig_path
  namespace        = "kube-coredns-lan"
  dns_ip           = local.config.k8s.local_dns_ipv4
  gateway_ip       = local.config.k8s.gateway.ipv4_address
  domains          = local.config.k8s.gateway.domains
}
