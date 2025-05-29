locals {
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
    name      = var.plex.name
    labels    = var.plex.labels
  }

  spec {
    selector {
      match_labels = {
        "app.kubernetes.io/name"     = var.plex.labels["app.kubernetes.io/name"]
        "app.kubernetes.io/instance" = var.plex.labels["app.kubernetes.io/instance"]
      }
    }

    template {
      metadata {
        labels = var.plex.labels
      }

      spec {
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  operator = "Exists"
                  key      = "device/gpu"
                }
              }
            }
          }
        }

        container {
          name              = var.plex.name
          image             = var.plex.image
          image_pull_policy = "IfNotPresent"

          env {
            name  = "VERSION"
            value = "docker"
          }

          env {
            name  = "ADVERTISE_IP"
            value = "https://${var.plex.domain}"
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
              cpu    = "2"
              memory = "16Gi"
            }
            requests = {
              cpu    = "1"
              memory = "4Gi"
            }
          }

          volume_mount {
            name       = "dev-dri"
            mount_path = "/dev/dri"
            read_only  = true
          }

          volume_mount {
            name       = "plex-config"
            mount_path = "/config"
          }

          volume_mount {
            name       = "movies"
            mount_path = "/movies"
          }

          volume_mount {
            name       = "tvshows"
            mount_path = "/tvshows"
          }
        }

        volume {
          name = "dev-dri"
          host_path {
            path = "/dev/dri"
            type = "Directory"
          }
        }

        volume {
          name = "plex-config"
          persistent_volume_claim {
            claim_name = "plex-config"
          }
        }

        volume {
          name = "movies"
          persistent_volume_claim {
            claim_name = "movies"
          }
        }

        volume {
          name = "tvshows"
          persistent_volume_claim {
            claim_name = "tvshows"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "plex" {
  metadata {
    namespace = var.namespace
    name      = var.plex.name
    labels    = var.plex.labels
  }

  spec {
    selector = {
      "app.kubernetes.io/name"     = var.plex.labels["app.kubernetes.io/name"]
      "app.kubernetes.io/instance" = var.plex.labels["app.kubernetes.io/instance"]
    }

    type             = "LoadBalancer"
    load_balancer_ip = var.plex.ip

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
