resource "kubernetes_role" "local_path_provisioner" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = var.labels
  }
  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list", "watch", "create", "patch", "update", "delete"]
  }
}
