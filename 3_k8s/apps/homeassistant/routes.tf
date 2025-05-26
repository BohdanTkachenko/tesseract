resource "kubernetes_manifest" "http_route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      namespace = var.namespace
      name      = "homeassistant"
      labels = {
        "app.kubernetes.io/name" = "homeassistant"
      }
    }
    spec = {
      parentRefs = [
        {
          namespace = var.gateway_namespace
          name      = var.gateway_name
        }
      ]
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
    }
  }
}
