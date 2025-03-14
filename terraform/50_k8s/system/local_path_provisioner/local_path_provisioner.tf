resource "helm_release" "local_path_provisioner" {
  name             = "local-path-provisioner"
  repository       = "https://charts.containeroo.ch"
  chart            = "local-path-provisioner"
  namespace        = var.namespace
  create_namespace = true
  values = [jsonencode({
    storageClass = {
      name = "any-local-path"
    }
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
  })]
}
