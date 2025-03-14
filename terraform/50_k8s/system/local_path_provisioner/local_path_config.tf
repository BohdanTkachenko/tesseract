resource "kubernetes_config_map_v1_data" "local_path_config" {
  depends_on = [helm_release.local_path_provisioner]
  metadata {
    name      = "local-path-config"
    namespace = var.namespace
  }
  force = true
  data = {
    "config.json" = jsonencode({
      nodePathMap = [
        {
          node  = "DEFAULT_PATH_FOR_NON_LISTED_NODES"
          paths = []
        },
        {
          node  = var.node_name
          paths = [for name, path in var.storage_classes : path]
        }
      ]
    })
    "helperPod.yaml" = "${file("${path.module}/helper_pod.yaml")}"
    "setup"          = "${file("${path.module}/setup")}"
    "teardown"       = "${file("${path.module}/teardown")}"
  }
}
