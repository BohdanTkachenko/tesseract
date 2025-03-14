resource "helm_release" "app" {
  name             = "app"
  repository       = "${path.module}/../../../../charts"
  chart            = "app"
  namespace        = var.namespace
  create_namespace = true
  values = [jsonencode({
    name = "whoami"
    image = {
      repository = "traefik/whoami"
      tag        = "latest"
    }
    ports = {
      http = {
        protocol      = "TCP"
        containerPort = 80
        targetPort    = "http"
      }
    }
    readinessProbe = {
      httpGet = {
        path = "/"
        port = "http"
      }
    }
    livenessProbe = {
      httpGet = {
        path = "/"
        port = "http"
      }
    }
    resources = {
      limits = {
        cpu    = "1"
        memory = "128Mi"
      }
      requests = {
        cpu    = "0.5"
        memory = "64Mi"
      }
    }
  })]
}
