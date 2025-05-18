resource "kubernetes_manifest" "http_route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      namespace = var.namespace
      name      = "whoami"
      labels = {
        "app.kubernetes.io/name" = "whoami"
      }
    }
    spec = {
      parentRefs = [
        {
          namespace = var.gateway_namespace
          name      = var.gateway_name
        }
      ]
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
    }
  }
}
