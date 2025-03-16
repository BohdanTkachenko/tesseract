
locals {
  volumes = {
    stash-config = {
      storage_class_name = var.stash_config_storage_class_name
      mount_path         = "/root/.stash"
      quota              = var.stash_config_quota
      read_only          = false
    }
    stash-metadata = {
      storage_class_name = var.stash_metadata_storage_class_name
      mount_path         = "/metadata"
      quota              = var.stash_metadata_quota
      read_only          = false
    }
    stash-cache = {
      storage_class_name = var.stash_cache_storage_class_name
      mount_path         = "/cache"
      quota              = var.stash_cache_quota
      read_only          = false
    }
    stash-blobs = {
      storage_class_name = var.stash_blobs_storage_class_name
      mount_path         = "/blobs"
      quota              = var.stash_blobs_quota
      read_only          = false
    }
    stash-generated = {
      storage_class_name = var.stash_generated_storage_class_name
      mount_path         = "/generated"
      quota              = var.stash_generated_quota
      read_only          = false
    }
    videos = {
      storage_class_name = var.videos_storage_class_name
      mount_path         = "/videos"
      quota              = var.videos_quota
      read_only          = false
    }
    images = {
      storage_class_name = var.images_storage_class_name
      mount_path         = "/images"
      quota              = var.images_quota
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
