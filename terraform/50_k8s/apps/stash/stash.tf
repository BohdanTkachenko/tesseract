locals {
  name = "stash"
  ports = {
    dlna-udp = {
      protocol       = "UDP"
      container_port = 1900
      target_port    = 1900
    }
    dlna-tcp = {
      protocol       = "TCP"
      container_port = 8200
      target_port    = 8200
    }
    stash = {
      protocol       = "TCP"
      container_port = 9999
      target_port    = 9999
    }
  }
}

resource "kubernetes_deployment" "stash" {
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
          image             = "stashapp/stash:latest"
          image_pull_policy = "IfNotPresent"

          env {
            name  = "STASH_GENERATED"
            value = "/generated/"
          }

          env {
            name  = "STASH_METADATA"
            value = "/metadata/"
          }

          env {
            name  = "STASH_CACHE"
            value = "/cache/"
          }

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
              path = "/healthz"
              port = 9999
            }
            initial_delay_seconds = 15
            timeout_seconds       = 5
          }

          liveness_probe {
            http_get {
              path = "/healthz"
              port = 9999
            }
            initial_delay_seconds = 10
            timeout_seconds       = 10
          }

          resources {
            limits = {
              cpu    = "8"
              memory = "16Gi"
            }
            requests = {
              cpu    = "2"
              memory = "4Gi"
            }
          }

          volume_mount {
            name       = "dev-dri"
            mount_path = "/dev/dri"
            read_only  = true
          }

          dynamic "volume_mount" {
            for_each = local.volumes
            content {
              name       = volume_mount.key
              mount_path = volume_mount.value.mount_path
            }
          }
        }

        volume {
          name = "dev-dri"
          host_path {
            path = "/dev/dri"
            type = "Directory"
          }
        }

        dynamic "volume" {
          for_each = local.volumes
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

resource "kubernetes_service" "stash" {
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

    type             = "LoadBalancer"
    load_balancer_ip = var.stash_ip

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
