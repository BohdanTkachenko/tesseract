module "ignition" {
  source = "./ignition"
  providers = {
    ignition = ignition
    kubernetes = kubernetes
    shell = shell
  }
  hostname     = var.hostname
  fcos_version = var.fcos_version
  nvidia       = var.nvidia
  wireguard    = var.wireguard
  k8s          = var.k8s
  mounts       = local.mounts
}

resource "libvirt_ignition" "ignition" {
  depends_on = [module.ignition]
  name       = "${var.hostname}.ign"
  pool       = var.pool_name
  content    = jsonencode(module.ignition.config)
}
