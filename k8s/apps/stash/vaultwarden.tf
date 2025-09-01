locals {
  vaultwarden_name = "vaultwarden"
  vaultwarden_ports = {
    http = {
      protocol       = "TCP"
      container_port = 80
      target_port    = "http"
    }
  }
}

resource "kubernetes_deployment" "vaultwarden" {
  metadata {
    namespace = var.namespace
    name      = local.vaultwarden_name
    labels = {
      "app.kubernetes.io/name" = local.vaultwarden_name
    }
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/name" = local.vaultwarden_name
      }
    }

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name" = local.vaultwarden_name
        }
      }

      spec {
        container {
          name              = local.vaultwarden_name
          image             = "vaultwarden/server:latest"
          image_pull_policy = "IfNotPresent"

          env {
            name  = "DOMAIN"
            value = "https://stash.tesseract.sh/passwords/"
          }

          dynamic "port" {
            for_each = local.vaultwarden_ports
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
              cpu    = "2"
              memory = "512Mi"
            }
            requests = {
              cpu    = "1"
              memory = "128Mi"
            }
          }

          dynamic "volume_mount" {
            for_each = local.vaultwarden_volumes
            content {
              name       = volume_mount.key
              mount_path = volume_mount.value.mount_path
            }
          }
        }

        dynamic "volume" {
          for_each = local.vaultwarden_volumes
          content {
            name = volume.key
            persistent_volume_claim {
              claim_name = volume.key
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
    name      = local.vaultwarden_name
    labels = {
      "app.kubernetes.io/name" = local.vaultwarden_name
    }
  }

  spec {
    selector = {
      "app.kubernetes.io/name" = local.vaultwarden_name
    }

    type = "ClusterIP"

    dynamic "port" {
      for_each = local.vaultwarden_ports
      content {
        name        = port.key
        protocol    = port.value.protocol
        port        = port.value.container_port
        target_port = port.value.target_port
      }
    }
  }
}
