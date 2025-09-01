include "root" {
  path = find_in_parent_folders("root.hcl")
}

dependency "crds" {
  config_path  = "${get_terragrunt_dir()}/crds"
  mock_outputs = {}
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("config.hcl")).inputs
}

inputs = {
  kube_config_path          = local.config.k8s.local.kubeconfig_path
  namespace                 = "kube-cilium"
  network_interface         = local.config.host.network.interface
  cluster_ipv4_network      = local.config.k8s.network.cluster.ipv4
  cluster_ipv6_network      = local.config.k8s.network.cluster.ipv6
  loadbalancer_ipv4_network = local.config.k8s.network.loadbalancer.ipv4
  loadbalancer_ipv6_network = local.config.k8s.network.loadbalancer.ipv6
  host_ip                   = local.config.host.network.ipv4_address
  gateway_name              = "cilium"
  gateway_ip                = local.config.k8s.gateway.ipv4_address
  domains                   = local.config.k8s.gateway.domains
}
