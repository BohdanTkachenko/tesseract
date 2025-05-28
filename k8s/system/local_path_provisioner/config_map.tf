resource "kubernetes_config_map" "local_path_config" {
  metadata {
    name      = "local-path-config"
    namespace = var.namespace
    labels    = var.labels
  }
  data = {
    "config.json" = jsonencode({
      storageClassConfigs = {
        for name, storage_class in var.storage_classes : storage_class.id => {
          nodePathMap = concat([
            {
              node  = "DEFAULT_PATH_FOR_NON_LISTED_NODES",
              paths = []
            }],
            [for node in storage_class.nodes : {
              node  = node
              paths = [storage_class.path]
          }])
        }
      }
    })
    "helperPod.yaml" = file("${path.module}/resources/helperPod.yaml")
    "setup"          = file("${path.module}/resources/setup")
    "teardown"       = file("${path.module}/resources/teardown")
  }
}
