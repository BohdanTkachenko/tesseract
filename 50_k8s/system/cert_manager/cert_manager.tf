resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = var.namespace
  create_namespace = true
  force_update     = true
  values = [jsonencode({
    installCRDs = true
    extraArgs = [
      "--dns01-recursive-nameservers=1.1.1.1:53,9.9.9.9:53",
      "--dns01-recursive-nameservers-only",
      "--enable-gateway-api",
    ]
    podDnsPolicy = "None",
    podDnsConfig = {
      nameservers = [
        "1.1.1.1",
        "9.9.9.9"
      ]
    }
  })]
}
