resource "kubernetes_storage_class" "storage_class" {
  for_each = var.storage_classes

  metadata {
    name   = each.value.id
    labels = var.labels
    annotations = {
      defaultVolumeType                             = "hostPath"
      "storageclass.kubernetes.io/is-default-class" = "false"
    }
  }
  storage_provisioner    = var.provisioner_name
  volume_binding_mode    = "WaitForFirstConsumer"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true
  parameters = {
    pathPattern = "{{ .PVC.Name }}"
  }
}
