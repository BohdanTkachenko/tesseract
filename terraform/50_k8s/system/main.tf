module "cilium" {
  source = "./cilium"
  providers = {
    kubectl = kubectl
    helm    = helm
  }

  namespace                 = "kube-cilium"
  network_interface         = var.network_interface
  cluster_ipv4_network      = var.network_cluster_ipv4
  cluster_ipv6_network      = var.network_cluster_ipv6
  loadbalancer_ipv4_network = var.network_loadbalancer_ipv4
  loadbalancer_ipv6_network = var.network_loadbalancer_ipv6
  host_ip                   = var.network_host_ip
  gateway_ip                = var.gateway_ip
  domains                   = var.gateway_domains
}

module "cert_manager" {
  depends_on = [module.cilium]
  source     = "./cert_manager"
  providers = {
    kubernetes = kubernetes
    kubectl    = kubectl
    helm       = helm
  }

  namespace            = "kube-cert-manager"
  letsencrypt_email    = var.cert_manager_letsencrypt_email
  cloudflare_api_token = var.cert_manager_cloudflare_api_token
}

module "coredns" {
  depends_on = [module.cilium]
  source     = "./coredns"
  providers = {
    helm = helm
  }

  namespace  = "kube-coredns-lan"
  dns_ip     = var.local_dns_ip
  gateway_ip = var.gateway_ip
  domains    = var.gateway_domains
}

module "dashboard" {
  depends_on = [module.cilium]
  source     = "./dashboard"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  namespace = "kube-dashboard"
}

module "local_path_provisioner" {
  depends_on = [module.cilium]
  source     = "./local_path_provisioner"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  namespace       = "kube-local-path-storage"
  node_name       = var.node_name
  storage_classes = var.storage_classes
}
