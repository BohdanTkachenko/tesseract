module "system" {
  source = "./system"
  providers = {
    kubernetes = kubernetes
    kubectl    = kubectl
    helm       = helm
  }

  node_name                         = var.node_name
  network_interface                 = var.network_interface
  network_cluster_ipv4              = var.network_cluster_ipv4
  network_cluster_ipv6              = var.network_cluster_ipv6
  network_loadbalancer_ipv4         = var.network_loadbalancer_ipv4
  network_loadbalancer_ipv6         = var.network_loadbalancer_ipv6
  network_host_ip                   = var.network_host_ip
  gateway_ip                        = var.gateway_ip
  gateway_domains                   = var.gateway_domains
  local_dns_ip                      = var.local_dns_ip
  cert_manager_letsencrypt_email    = var.cert_manager_letsencrypt_email
  cert_manager_cloudflare_api_token = var.cert_manager_cloudflare_api_token
  storage_classes                   = var.storage_classes
}
