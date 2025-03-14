resource "kubernetes_storage_class" "local_path" {
  depends_on = [helm_release.local_path_provisioner]
  for_each   = var.storage_classes

  metadata {
    name = replace(each.key, "_", "-")
  }
  storage_provisioner = "rancher.io/local-path"
  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"
  parameters = {
    nodePath    = each.value
    pathPattern = "{{ .PVC.Namespace }}/{{ .PVC.Name }}"
  }
}
