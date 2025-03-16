resource "kubernetes_manifest" "http_route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      namespace = var.namespace
      name      = "media"
      labels = {
        "app.kubernetes.io/name" = "media"
      }
    }
    spec = {
      parentRefs = [
        {
          namespace = var.gateway_namespace
          name      = var.gateway_name
        }
      ]
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
    }
  }
}
