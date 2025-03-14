resource "helm_release" "app" {
  name             = "app"
  repository       = "${path.module}/../../../../charts"
  chart            = "app"
  namespace        = var.namespace
  create_namespace = true
  values = [jsonencode({
    name = "stash"
    image = {
      repository = "stashapp/stash"
      tag        = "latest"
    }
    env = {
      STASH_GENERATED = "/generated/"
      STASH_METADATA  = "/metadata/"
      STASH_CACHE     = "/cache/"
    }
    service = {
      type           = "LoadBalancer"
      loadBalancerIP = var.stash_ip
    }
    ports = {
      dlna-udp = {
        protocol      = "UDP"
        containerPort = 1900
        targetPort    = 1900
      }
      dlna-tcp = {
        protocol      = "TCP"
        containerPort = 8200
        targetPort    = 8200
      }
      stash = {
        protocol      = "TCP"
        containerPort = 9999
        targetPort    = 9999
      }
    }
    readinessProbe = {
      httpGet = {
        path = "/healthz"
        port = 9999
      }
      initialDelaySeconds = 15
      timeoutSeconds      = 5
    }
    livenessProbe = {
      httpGet = {
        path = "/healthz"
        port = 9999
      }
      initialDelaySeconds = 10
      timeoutSeconds      = 10
    }
    volumes = {
      dri = true
      persistent = {
        stash-config = {
          storageClassName = var.stash_config_storage_class_name
          mountPath        = "/root/.stash"
          quota            = var.stash_config_quota
          readOnly         = false
        }
        stash-metadata = {
          storageClassName = var.stash_metadata_storage_class_name
          mountPath        = "/metadata"
          quota            = var.stash_metadata_quota
          readOnly         = false
        }
        stash-cache = {
          storageClassName = var.stash_cache_storage_class_name
          mountPath        = "/cache"
          quota            = var.stash_cache_quota
          readOnly         = false
        }
        stash-blobs = {
          storageClassName = var.stash_blobs_storage_class_name
          mountPath        = "/blobs"
          quota            = var.stash_blobs_quota
          readOnly         = false
        }
        stash-generated = {
          storageClassName = var.stash_generated_storage_class_name
          mountPath        = "/generated"
          quota            = var.stash_generated_quota
          readOnly         = false
        }
        videos = {
          storageClassName = var.videos_storage_class_name
          mountPath        = "/videos"
          quota            = var.videos_quota
          readOnly         = false
        }
        images = {
          storageClassName = var.images_storage_class_name
          mountPath        = "/images"
          quota            = var.images_quota
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
