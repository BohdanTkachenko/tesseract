resource "helm_release" "plex_httproutes" {
  name             = "httproutes"
  repository       = "${path.module}/../../../../charts"
  chart            = "httproutes"
  namespace        = var.namespace
  create_namespace = true
  values = [jsonencode({
    name      = "plex"
    hostnames = [var.plex_domain]
    rules = [
      {
        backendRefs = [
          {
            name = "plex"
            port = 32400
          }
        ]
      }
    ]
  })]
}
