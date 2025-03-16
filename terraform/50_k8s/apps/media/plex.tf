locals {
  name = "plex"
  ports = {
    plex = {
      protocol       = "TCP"
      container_port = "32400"
      target_port    = "32400"
    }
    dlna-udp = {
      protocol       = "UDP"
      container_port = "1900"
      target_port    = "1900"
    }
    bonjour = {
      protocol       = "UDP"
      container_port = "5353"
      target_port    = "5353"
    }
    roku = {
      protocol       = "TCP"
      container_port = "8324"
      target_port    = "8324"
    }
    gdm-32410 = {
      protocol       = "UDP"
      container_port = "32410"
      target_port    = "32410"
    }
    gdm-32412 = {
      protocol       = "UDP"
      container_port = "32412"
      target_port    = "32412"
    }
    gdm-32413 = {
      protocol       = "UDP"
      container_port = "32413"
      target_port    = "32413"
    }
    gdm-32414 = {
      protocol       = "UDP"
      container_port = "32414"
      target_port    = "32414"
    }
    dlna-tcp = {
      protocol       = "TCP"
      container_port = "32469"
      target_port    = "32469"
    }
  }
}

resource "kubernetes_deployment" "plex" {
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
          image             = "lscr.io/linuxserver/plex:latest"
          image_pull_policy = "IfNotPresent"

          env {
            name  = "VERSION"
            value = "docker"
          }

          env {
            name  = "ADVERTISE_IP"
            value = "https://${var.plex_domain}"
          }

          env {
            name  = "TZ"
            value = var.timezone
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
              path = "/identity"
              port = 32400
            }
            initial_delay_seconds = 15
            timeout_seconds       = 5
          }

          liveness_probe {
            http_get {
              path = "/identity"
              port = 32400
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

resource "kubernetes_service" "plex" {
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
    load_balancer_ip = var.plex_ip

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
