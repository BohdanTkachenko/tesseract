locals {
  loadbalancer_ipv4_network = "10.42.0.0/24"
  gateway_ip                = cidrhost(local.loadbalancer_ipv4_network, 80)
  domains                   = ["tesseract.sh", "cyber.place"]
}

module "cilium" {
  source = "./cilium"
  providers = {
    kubernetes = kubernetes
    kubectl    = kubectl
    helm       = helm
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
