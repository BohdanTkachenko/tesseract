locals {
  secret_vars     = yamldecode(sops_decrypt_file("./secrets.yaml"))
  storage_classes = read_terragrunt_config("./storage_classes.hcl").inputs
}

inputs = {
  gpu = {
    labels = {
      "device/gpu" = "true"
    }
    vcpu          = 4
    memory_mb     = 16384 # 16 GiB
    disk_size_gib = 32
    nvidia        = true
    host_devices = [{
      // GPU
      source_bus   = "0x01"
      source_slot  = "0x00"
      address_bus  = "0x00"
      address_slot = "0x0a"
    }]
    mounts = [
      local.storage_classes.media_fast.path,
      local.storage_classes.media_slow.path,
    ]
    wireguard = null
  }

  seedbox = {
    labels        = {}
    vcpu          = 2
    memory_mb     = 8192 # 8 GiB
    disk_size_gib = 32
    nvidia        = false
    host_devices  = []
    mounts = [
      local.storage_classes.media_fast.path,
      local.storage_classes.media_slow.path,
    ]
    wireguard = {
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