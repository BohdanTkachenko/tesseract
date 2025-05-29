resource "kubernetes_manifest" "plex_http_route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      namespace = var.namespace
      name      = "media"
      labels    = var.plex.labels
    }
    spec = {
      parentRefs = [var.gateway]
      hostnames  = [var.plex.domain]
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
    }
  }
}
