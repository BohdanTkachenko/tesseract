variable "kubernetes_config_path" {
  type    = string
  default = "~/.kube/config"
}

variable "node_name" {
  type    = string
  default = "tesseract.sh"
}

variable "network_interface" {
  type    = string
  default = "enp3s0"
}

variable "network_cluster_ipv4" {
  type    = string
  default = "10.244.0.0/16"
}

variable "network_cluster_ipv6" {
  type    = string
  default = "fd42:1ee7::/104"
}

variable "network_loadbalancer_ipv4" {
  type    = string
  default = "10.42.0.0/24"
}

variable "network_loadbalancer_ipv6" {
  type    = string
  default = "fd42:c0de::/112"
}

variable "network_host_ip" {
  type    = string
  default = "10.42.0.1"
}

variable "gateway_ip" {
  type    = string
  default = "10.42.0.80"
}

variable "gateway_domains" {
  type    = list(string)
  default = ["tesseract.sh", "cyber.place"]
}

variable "local_dns_ip" {
  type    = string
  default = "10.42.0.53"
}

variable "cert_manager_letsencrypt_email" {
  type    = string
  default = "dan@cyber.place"
}

variable "cert_manager_cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "storage_classes" {
  type = map(string)
  default = {
    fast_local_path = "/var/lib/volumes"
    slow_local_path = "/mnt/hdd/volumes"
  }
}
