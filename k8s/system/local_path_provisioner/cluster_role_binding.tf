resource "kubernetes_cluster_role_binding" "local_path_provisioner" {
  metadata {
    name   = var.name
    labels = var.labels
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = resource.kubernetes_cluster_role.local_path_provisioner.metadata[0].name
  }
  subject {
    kind      = "ServiceAccount"
    name      = resource.kubernetes_service_account.local_path_provisioner.metadata[0].name
    namespace = resource.kubernetes_service_account.local_path_provisioner.metadata[0].namespace
  }
}
