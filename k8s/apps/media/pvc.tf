resource "kubernetes_persistent_volume_claim" "pvc" {
  for_each = var.volumes

  metadata {
    name      = each.value.name
    namespace = var.namespace
    labels    = each.value.labels
    annotations = {
      volume_type = "local"
    }
  }
  spec {
    storage_class_name = each.value.storage_class
    access_modes       = each.value.access_modes
    resources {
      requests = {
        storage = each.value.quota
      }
    }
  }
}
