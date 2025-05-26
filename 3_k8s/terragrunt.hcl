dependency "metal" {
  config_path = "../1_metal"
}

dependency "k8s_crds" {
  config_path  = "../2_k8s_crds"
  mock_outputs = {}
}

locals {
  secret_vars = yamldecode(sops_decrypt_file(find_in_parent_folders("secrets.yaml")))
  config      = read_terragrunt_config(find_in_parent_folders("config.hcl")).inputs
}

inputs = {
  kube_config_path                  = dependency.metal.outputs.kube_config_path
  network_interface                 = local.config.host.network.interface
  network_cluster_ipv4              = local.config.k8s.network.cluster.ipv4
  network_cluster_ipv6              = local.config.k8s.network.cluster.ipv6
  network_loadbalancer_ipv4         = local.config.k8s.network.loadbalancer.ipv4
  network_loadbalancer_ipv6         = local.config.k8s.network.loadbalancer.ipv6
  network_host_ip                   = local.config.host.network.ipv4_address
  gateway_ip                        = local.config.k8s.gateway.ipv4_address
  gateway_domains                   = local.config.k8s.gateway.domains
  local_dns_ip                      = local.config.k8s.local_dns_ipv4
  cert_manager_letsencrypt_email    = local.config.k8s.cert_manager.admin_email
  cert_manager_cloudflare_api_token = local.secret_vars.cert_manager_cloudflare_api_token
  storage_classes                   = local.config.k8s.storage_classes
}