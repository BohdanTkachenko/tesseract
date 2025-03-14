resource "helm_release" "reverse_proxy" {
  name             = "reverseproxy"
  repository       = "${path.module}/../../../../charts"
  chart            = "reverseproxy"
  namespace        = var.namespace
  create_namespace = true
  values = [jsonencode({
    name    = "homeassistant"
    address = var.homeassistant_address
  })]
}

