resource "helm_release" "local_path_provisioner" {
  name             = "local-path-provisioner"
  repository       = "https://charts.containeroo.ch"
  chart            = "local-path-provisioner"
  namespace        = var.namespace
  create_namespace = true
  values = [jsonencode({
    configmap = {
      name = "local-path-config"
      helperPod = {
        namespaceOverride = ""
        name              = "helper-pod"
        annotations       = {}
      }
      setup    = file("${path.module}/setup")
      teardown = file("${path.module}/teardown")
    }
    nodePathMap = []
    storageClassConfigs = {
      for name, path in var.storage_classes : name => {
        storageClass = {
          create            = true
          defaultClass      = false
          defaultVolumeType = "hostPath"
          reclaimPolicy     = "Delete"
          volumeBindingMode = "WaitForFirstConsumer"
          pathPattern       = "{{ .PVC.Namespace }}/{{ .PVC.Name }}"
        }
        nodePathMap = [
          {
            node  = "DEFAULT_PATH_FOR_NON_LISTED_NODES"
            paths = []
          },
          {
            node  = var.node_name
            paths = [path]
          }
        ]
      }
    }
  })]
}
