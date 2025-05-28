resource "kubernetes_cluster_role" "local_path_provisioner" {
  metadata {
    name   = var.name
    labels = var.labels
  }
  rule {
    api_groups = [""]
    resources  = ["nodes", "persistentvolumeclaims", "configmaps", "pods", "pods/log"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""]
    resources  = ["persistentvolumes"]
    verbs      = ["get", "list", "watch", "create", "patch", "update", "delete"]
  }
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }
  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
    verbs      = ["get", "list", "watch"]
  }
}
