resource "helm_release" "http_route" {
  depends_on       = [helm_release.app]
  name             = "httproutes"
  repository       = "${path.module}/../../../../charts"
  chart            = "httproutes"
  namespace        = var.namespace
  create_namespace = true
  values = [jsonencode({
    name      = "whoami"
    hostnames = [var.whoami_domain]
    rules = [
      {
        backendRefs = [
          {
            name = "whoami"
            port = 80
          }
        ]
      }
    ]
  })]
}
