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
          name      = "cilium"
          namespace = "kube-cilium"
        }
      ]
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
