resource "helm_release" "cilium" {
  depends_on       = [kubectl_manifest.gateway_crds]
  name             = "cilium"
  repository       = "https://helm.cilium.io/"
  chart            = "cilium"
  namespace        = var.namespace
  create_namespace = true
  values = [templatefile("${path.module}/values.tpl.yaml", {
    namespace            = var.namespace
    network_interface    = var.network_interface
    cluster_ipv4_network = var.cluster_ipv4_network
    cluster_ipv6_network = var.cluster_ipv6_network
    host_ip              = var.host_ip
  })]
}
