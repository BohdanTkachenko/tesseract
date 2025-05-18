dependency "vms" {
  config_path  = "../30_vms"
  mock_outputs = {}
}

dependency "k8s_crds" {
  config_path  = "../45_k8s_crds"
  mock_outputs = {}
}

locals {
  secret_vars = yamldecode(sops_decrypt_file(find_in_parent_folders("secrets.yaml")))
}

inputs = {
  kubernetes_config_path            = "~/.kube/config"
  network_interface                 = "enp3s0"
  network_cluster_ipv4              = "10.244.0.0/16"
  network_cluster_ipv6              = "fd42:1ee7::/104"
  network_loadbalancer_ipv4         = "10.42.0.0/24"
  network_loadbalancer_ipv6         = "fd42:c0de::/112"
  network_host_ip                   = "10.42.0.1"
  gateway_ip                        = "10.42.0.80"
  gateway_domains                   = ["tesseract.sh", "cyber.place"]
  local_dns_ip                      = "10.42.0.53"
  cert_manager_letsencrypt_email    = "dan@cyber.place"
  cert_manager_cloudflare_api_token = local.secret_vars.cert_manager_cloudflare_api_token
  storage_classes = {
    fast-local-path = {
      path  = "/var/lib/volumes"
      nodes = ["tesseract.sh"]
    },
    slow-local-path = {
      path  = "/mnt/hdd/volumes"
      nodes = ["tesseract.sh"]
    },
    media-fast-local = {
      path  = "/var/lib/volumes/media"
      nodes = ["seedbox"]
    },
    media-slow-local = {
      path  = "/var/mnt/hdd/volumes/media",
      nodes = ["seedbox"]
    },
  }
}