variable "kube_config_path" {
  type = string
}

variable "network_interface" {
  type = string
}

variable "network_cluster_ipv4" {
  type = string
}

variable "network_cluster_ipv6" {
  type = string
}

variable "network_loadbalancer_ipv4" {
  type = string
}

variable "network_loadbalancer_ipv6" {
  type = string
}

variable "network_host_ip" {
  type = string
}

variable "gateway_ip" {
  type = string
}

variable "gateway_domains" {
  type = list(string)
}

variable "local_dns_ip" {
  type = string
}

variable "cert_manager_letsencrypt_email" {
  type = string
}

variable "cert_manager_cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "storage_classes" {
  type = map(object({
    path  = string
    nodes = list(string)
  }))
}
