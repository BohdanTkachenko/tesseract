module "ignition" {
  source = "./ignition"
  providers = {
    ignition = ignition
    ssh      = ssh
  }
  hostname  = var.hostname
  ssh       = var.ssh
  wireguard = var.wireguard
  k8s       = var.k8s
  mounts    = local.mounts
}

resource "libvirt_ignition" "ignition" {
  depends_on = [module.ignition]
  name       = "${var.hostname}.ign"
  pool       = var.pool_name
  content    = jsonencode(module.ignition.config)
}
