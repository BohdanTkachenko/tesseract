locals {
  vm_seedbox_wireguard = var.wireguard.proton_us_nj_242
}

module "vm_seedbox" {
  depends_on = [
    libvirt_pool.main,
    libvirt_network.main,
    module.fcos,
  ]
  source = "./vm"
  providers = {
    libvirt  = libvirt
    ignition = ignition
    ssh      = ssh
  }
  ssh = var.ssh
  k8s = {
    version = var.k8s.version
    server  = data.shell_script.k8s_ca_hash.output.server
    ca_hash = data.shell_script.k8s_ca_hash.output.ca_hash
  }
  fcos_volume_id = module.fcos.volume_id
  pool_name      = libvirt_pool.main.name
  network_name   = libvirt_network.main.name

  hostname      = "seedbox"
  vcpu          = 2
  memory_mb     = 8192 # 8 GiB
  disk_size_gib = 32
  mounts = [
    "/var/lib/volumes/media",
    "/var/mnt/hdd/volumes/media",
  ]
  wireguard = local.vm_seedbox_wireguard
}

resource "kubernetes_labels" "node" {
  depends_on = [module.vm_seedbox]

  api_version = "v1"
  kind        = "Node"
  metadata {
    name = "seedbox"
  }
  labels = {
    "net/vpn"                = true
    "net/vpn_country"        = local.vm_seedbox_wireguard.vpn_country,
    "net/vpn_country_region" = local.vm_seedbox_wireguard.vpn_city,
    "net/vpn_p2p"            = local.vm_seedbox_wireguard.vpn_p2p,
    "net/vpn_private"        = local.vm_seedbox_wireguard.vpn_private,
    "net/vpn_tor"            = local.vm_seedbox_wireguard.vpn_tor,
    "net/vpn_streaming"      = local.vm_seedbox_wireguard.vpn_streaming,
  }
}

