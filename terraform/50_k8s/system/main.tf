locals {
  loadbalancer_ipv4_network = "10.42.0.0/24"
  dns_ip                    = cidrhost(local.loadbalancer_ipv4_network, 53)
  gateway_ip                = cidrhost(local.loadbalancer_ipv4_network, 80)
  domains                   = ["tesseract.sh", "cyber.place"]
}

module "cilium" {
  source = "./cilium"
  providers = {
    kubectl = kubectl
    helm    = helm
  }

  namespace                 = "kube-cilium"
  network_interface         = "enp3s0"
  cluster_ipv4_network      = "10.244.0.0/16"
  cluster_ipv6_network      = "fd42:1ee7::/104"
  loadbalancer_ipv4_network = local.loadbalancer_ipv4_network
  loadbalancer_ipv6_network = "fd42:c0de::/112"
  host_ip                   = cidrhost(local.loadbalancer_ipv4_network, 1)
  gateway_ip                = local.gateway_ip
  domains                   = local.domains
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
  letsencrypt_email    = var.letsencrypt_email
  cloudflare_api_token = var.cloudflare_api_token
}

module "coredns" {
  depends_on = [module.cilium]
  source     = "./coredns"
  providers = {
    helm = helm
  }

  namespace  = "kube-coredns-lan"
  dns_ip     = local.dns_ip
  gateway_ip = local.gateway_ip
  domains    = local.domains
}
