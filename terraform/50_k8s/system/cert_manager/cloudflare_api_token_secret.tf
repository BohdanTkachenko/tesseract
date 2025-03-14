resource "kubernetes_secret" "cloudflare_api_token_secret" {
  depends_on = [helm_release.cert_manager]
  metadata {
    name      = "cloudflare-api-token-secret"
    namespace = var.namespace
  }
  type = "Opaque"
  data = {
    api-token = var.cloudflare_api_token
  }
}
