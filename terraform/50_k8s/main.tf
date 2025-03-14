module "system" {
  source = "./system"
  providers = {
    kubernetes = kubernetes
    kubectl    = kubectl
    helm       = helm
  }

  letsencrypt_email    = var.letsencrypt_email
  cloudflare_api_token = var.cloudflare_api_token
}
