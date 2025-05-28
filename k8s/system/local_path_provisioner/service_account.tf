resource "kubernetes_service_account" "local_path_provisioner" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = var.labels
  }
}
