module "fcos" {
  depends_on = [libvirt_pool.main]
  source     = "./fcos"
  providers = {
    http    = http
    shell   = shell
    libvirt = libvirt
  }

  fcos      = var.fcos
  pool_name = libvirt_pool.main.name
}
