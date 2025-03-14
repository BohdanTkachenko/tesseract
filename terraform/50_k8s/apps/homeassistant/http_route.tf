resource "helm_release" "http_route" {
  depends_on       = [helm_release.reverse_proxy]
  name             = "httproutes"
  repository       = "${path.module}/../../../../charts"
  chart            = "httproutes"
  namespace        = var.namespace
  create_namespace = true
  values = [jsonencode({
    name      = "homeassistant"
    hostnames = [var.homeassistant_domain]
    rules = [
      {
        backendRefs = [
          {
            name = "homeassistant"
            port = 80
          }
        ]
      }
    ]
  })]
}
