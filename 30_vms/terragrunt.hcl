dependency "metal" {
  config_path = "../10_metal"
}

locals {
  secret_vars = yamldecode(sops_decrypt_file(find_in_parent_folders("secrets.yaml")))
}

inputs = {
  ssh = {
    agent               = false
    host                = "tesseract.lan"
    port                = 22
    user                = "terraform"
    password            = null
    private_key         = "~/.ssh/terraform"
    bastion_host        = null
    bastion_port        = null
    bastion_user        = null
    bastion_password    = null
    bastion_private_key = null
  }
  fcos = {
    stream_url   = "https://builds.coreos.fedoraproject.org/streams/stable.json"
    architecture = "x86_64"
    platform     = "qemu"
    format       = "qcow2.xz"
    local_dir    = "/tmp"
  }
  k8s = {
    version = "1.32"
    ca_path = "~/.kube/ca.crt"
  }
  kubernetes_config_path = "~/.kube/config"
  wireguard = {
    proton_us_nj_242 = {
      vpn_country   = "US"
      vpn_city      = "NJ"
      vpn_p2p       = true
      vpn_private   = true
      vpn_tor       = false
      vpn_streaming = true
      if_name       = "prtn-us-nj-242"
      public_key    = "R0J2HK9bYV4Ww6tMk76hiTwiWbC6JvxqhvSNeO4tIhg="
      private_key   = local.secret_vars.proton_vpn_private_key
      vpn_host      = "151.243.141.5"
      vpn_port      = 51820
      vpn_net       = "10.2.0.0/16"
      lan_net       = "10.0.0.0/8"
    }
  }
}