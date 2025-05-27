module "vms" {
  for_each = var.vms

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
  ssh            = var.ssh
  k8s            = var.k8s
  fcos_version   = module.fcos.version
  fcos_volume_id = module.fcos.volume_id
  pool_name      = libvirt_pool.main.name
  network_name   = libvirt_network.main.name

  hostname      = each.key
  vcpu          = each.value.vcpu
  memory_mb     = each.value.memory_mb
  disk_size_gib = each.value.disk_size_gib
  nvidia        = each.value.nvidia
  host_devices  = each.value.host_devices
  mounts        = each.value.mounts
  wireguard     = each.value.wireguard
}

resource "kubernetes_labels" "node" {
  depends_on = [module.vms]
  for_each   = var.vms

  api_version = "v1"
  kind        = "Node"
  metadata {
    name = each.key
  }
  labels = merge(each.value.labels, {
    "net/vpn"                = each.value.wireguard != null
    "net/vpn_country"        = each.value.wireguard != null ? each.value.wireguard.vpn_country : null,
    "net/vpn_country_region" = each.value.wireguard != null ? each.value.wireguard.vpn_city : null,
    "net/vpn_p2p"            = each.value.wireguard != null ? each.value.wireguard.vpn_p2p : null,
    "net/vpn_private"        = each.value.wireguard != null ? each.value.wireguard.vpn_private : null,
    "net/vpn_tor"            = each.value.wireguard != null ? each.value.wireguard.vpn_tor : null,
    "net/vpn_streaming"      = each.value.wireguard != null ? each.value.wireguard.vpn_streaming : null,
  })
}

