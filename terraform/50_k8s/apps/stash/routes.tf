resource "kubernetes_manifest" "http_route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      namespace = var.namespace
      name      = "stash"
      labels = {
        "app.kubernetes.io/name" = "stash"
      }
    }
    spec = {
      parentRefs = [
        {
          namespace = var.gateway_namespace
          name      = var.gateway_name
        }
      ]
      hostnames = [var.stash_domain]
      rules = [
        {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/passwords"
              }
            }
          ]
          backendRefs = [
            {
              name = "vaultwarden"
              port = 80
            }
          ]
        },
        {
          backendRefs = [
            {
              name = "stash"
              port = 9999
            }
          ]
        }
      ]
    }
  }
}
