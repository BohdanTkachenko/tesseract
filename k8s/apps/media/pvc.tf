resource "kubernetes_persistent_volume_claim" "plex_config" {
  metadata {
    name      = "plex-config"
    namespace = var.namespace
    labels    = var.plex.labels
    annotations = {
      volume_type = "local"
    }
  }
  spec {
    storage_class_name = var.plex_config_storage_class_name
    access_modes       = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.plex_config_quota
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "movies" {
  metadata {
    name      = "movies"
    namespace = var.namespace
    labels    = var.plex.labels
    annotations = {
      volume_type = "local"
    }
  }
  spec {
    storage_class_name = var.movies_storage_class_name
    access_modes       = ["ReadWriteMany"]
    resources {
      requests = {
        storage = var.movies_quota
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "tvshows" {
  metadata {
    name      = "tvshows"
    namespace = var.namespace
    labels    = var.plex.labels
    annotations = {
      volume_type = "local"
    }
  }
  spec {
    storage_class_name = var.tvshows_storage_class_name
    access_modes       = ["ReadWriteMany"]
    resources {
      requests = {
        storage = var.tvshows_quota
      }
    }
  }
}
