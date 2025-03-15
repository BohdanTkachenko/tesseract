locals {
  name = "whoami"
  ports = {
    http = {
      protocol       = "TCP"
      container_port = 80
      target_port    = "http"
    }
  }
}

resource "kubernetes_deployment" "whoami" {
  metadata {
    namespace = var.namespace
    name      = local.name
    labels = {
      "app.kubernetes.io/name" = local.name
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/name" = local.name
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = local.name
        }
      }

      spec {
        container {
          name              = local.name
          image             = "traefik/whoami:latest"
          image_pull_policy = "IfNotPresent"

          dynamic "port" {
            for_each = local.ports
            content {
              name           = port.key
              protocol       = port.value.protocol
              container_port = port.value.container_port
            }
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "http"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = "http"
            }
          }

          resources {
            limits = {
              cpu    = "1"
              memory = "128Mi"
            }
            requests = {
              cpu    = "0.5"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "whoami" {
  metadata {
    namespace = var.namespace
    name      = local.name
    labels = {
      "app.kubernetes.io/name" = local.name
    }
  }

  spec {
    selector = {
      "app.kubernetes.io/name" = local.name
    }

    type = "ClusterIP"

    dynamic "port" {
      for_each = local.ports
      content {
        name        = port.key
        protocol    = port.value.protocol
        port        = port.value.container_port
        target_port = port.value.target_port
      }
    }
  }
}
