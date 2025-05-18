resource "helm_release" "coredns" {
  name             = "coredns"
  repository       = "https://coredns.github.io/helm"
  chart            = "coredns"
  namespace        = var.namespace
  create_namespace = true
  values = [templatefile("${path.module}/values.tpl.yaml", {
    dns_ip     = var.dns_ip
    gateway_ip = var.gateway_ip
    domains    = var.domains
  })]
}
