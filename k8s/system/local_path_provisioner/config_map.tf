resource "kubernetes_config_map" "local_path_config" {
  metadata {
    name      = "local-path-config"
    namespace = var.namespace
    labels    = var.labels
  }
  data = {
    "config.json" = jsonencode({
      storageClassConfigs = {
        for key, value in var.storage_classes : value.id => {
          sharedFileSystemPath = value.path
        }
      }
    })
    "helperPod.yaml" = templatefile("${path.module}/resources/helperPod.yaml", {
      node_name = var.main_node_name
    })
    "setup"    = file("${path.module}/resources/setup")
    "teardown" = file("${path.module}/resources/teardown")
  }
}
