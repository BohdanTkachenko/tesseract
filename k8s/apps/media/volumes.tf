
locals {
  volumes = {
    plex-config = {
      storage_class_name = var.plex_config_storage_class_name
      mount_path         = "/config"
      quota              = var.plex_config_quota
      read_only          = false
    }
    movies = {
      storage_class_name = var.movies_storage_class_name
      mount_path         = "/movies"
      quota              = var.movies_quota
      read_only          = false
    }
    tvshows = {
      storage_class_name = var.tvshows_storage_class_name
      mount_path         = "/tvshows"
      quota              = var.tvshows_quota
      read_only          = false
    }
  }
}

resource "kubernetes_persistent_volume_claim" "pvc" {
  for_each = local.volumes
  metadata {
    namespace = var.namespace
    name      = each.key
    annotations = {
      volume_type = "local"
    }
  }
  spec {
    storage_class_name = each.value.storage_class_name
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = each.value.quota
      }
    }
  }
}
