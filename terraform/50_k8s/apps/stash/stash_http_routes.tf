resource "helm_release" "stash_httproutes" {
  name             = "httproutes"
  repository       = "${path.module}/../../../../charts"
  chart            = "httproutes"
  namespace        = var.namespace
  create_namespace = true
  values = [jsonencode({
    name      = "stash"
    hostnames = [var.stash_domain]
    rules = [
      {
        backendRefs = [
          {
            name = "stash"
            port = 9999
          }
        ]
      }
    ]
  })]
}
