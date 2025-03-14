resource "helm_release" "app" {
  name             = "app"
  repository       = "${path.module}/../../../../charts"
  chart            = "app"
  namespace        = var.namespace
  create_namespace = true
  values = [jsonencode({
    name = "plex"
    image = {
      repository = "lscr.io/linuxserver/plex"
      tag        = "latest"
    }
    env = {
      VERSION      = "docker"
      ADVERTISE_IP = "https://${var.plex_domain}"
      TZ           = var.timezone
    }
    service = {
      type           = "LoadBalancer"
      loadBalancerIP = var.plex_ip
    }
    ports = {
      plex = {
        protocol      = "TCP"
        containerPort = "32400"
        targetPort    = "32400"
      }
      dlna-udp = {
        protocol      = "UDP"
        containerPort = "1900"
        targetPort    = "1900"
      }
      bonjour = {
        protocol      = "UDP"
        containerPort = "5353"
        targetPort    = "5353"
      }
      roku = {
        protocol      = "TCP"
        containerPort = "8324"
        targetPort    = "8324"
      }
      gdm-32410 = {
        protocol      = "UDP"
        containerPort = "32410"
        targetPort    = "32410"
      }
      gdm-32412 = {
        protocol      = "UDP"
        containerPort = "32412"
        targetPort    = "32412"
      }
      gdm-32413 = {
        protocol      = "UDP"
        containerPort = "32413"
        targetPort    = "32413"
      }
      gdm-32414 = {
        protocol      = "UDP"
        containerPort = "32414"
        targetPort    = "32414"
      }
      dlna-tcp = {
        protocol      = "TCP"
        containerPort = "32469"
        targetPort    = "32469"
      }
    }
    readinessProbe = {
      httpGet = {
        path = "/identity"
        port = 32400
      }
      initialDelaySeconds = 15
      timeoutSeconds      = 5
    }
    livenessProbe = {
      httpGet = {
        path = "/identity"
        port = 32400
      }
      initialDelaySeconds = 10
      timeoutSeconds      = 10
    }
    volumes = {
      dri = true
      persistent = {
        plex-config = {
          storageClassName = var.plex_config_storage_class_name
          mountPath        = "/config"
          quota            = var.plex_config_quota
          readOnly         = false
        }
        movies = {
          storageClassName = var.movies_storage_class_name
          mountPath        = "/movies"
          quota            = var.movies_quota
          readOnly         = false
        }
        tvshows = {
          storageClassName = var.tvshows_storage_class_name
          mountPath        = "/tvshows"
          quota            = var.tvshows_quota
          readOnly         = false
        }
      }
    }
    resources = {
      limits = {
        cpu    = "8"
        memory = "16Gi"
      }
      requests = {
        cpu    = "2"
        memory = "4Gi"
      }
    }
  })]
}
