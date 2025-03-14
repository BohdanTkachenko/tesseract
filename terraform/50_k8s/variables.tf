variable "kubernetes_config_path" {
  type    = string
  default = "~/.kube/config"
}

variable "letsencrypt_email" {
  type    = string
  default = "dan@cyber.place"
}

variable "cloudflare_api_token" {
  type = string
}
