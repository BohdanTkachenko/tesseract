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
      for name, storage_class in var.storage_classes : storage_class.id => {
        storageClass = {
          create            = true
          defaultClass      = false
          defaultVolumeType = "hostPath"
          reclaimPolicy     = "Delete"
          volumeBindingMode = "WaitForFirstConsumer"
          pathPattern       = "{{ .PVC.Name }}"
        }
        nodePathMap = concat([{
          node  = "DEFAULT_PATH_FOR_NON_LISTED_NODES"
          paths = []
          }], [for node in storage_class.nodes : {
          node  = node
          paths = [storage_class.path]
        }])
      }
    }
  })]
}
