module "base" {
  source = "./base"
  providers = {
    ignition = ignition
  }
  hostname = var.hostname
}

module "mounts" {
  depends_on = [module.base]
  source     = "./mounts"
  providers = {
    ignition = ignition
  }
  mounts = var.mounts
}

module "wireguard" {
  depends_on = [module.base]
  source     = "./wireguard"
  count      = var.wireguard == null ? 0 : 1
  providers = {
    ignition = ignition
  }
  wireguard = var.wireguard
}

module "k8s_install" {
  depends_on = [module.base]
  source     = "./k8s_install"
  count      = var.k8s == null ? 0 : 1
  providers = {
    ignition = ignition
  }
  k8s_version = var.k8s.version
}

locals {
  modules = [
    for m in [
      module.base,
      module.mounts,
      var.wireguard == null ? null : module.wireguard[0],
      var.k8s == null ? null : module.k8s_install[0],
    ] : m if m != null
  ]
}

module "k8s_join" {
  depends_on = [module.base, module.mounts, module.wireguard, module.k8s_install]
  source     = "./k8s_join"
  count      = var.k8s == null ? 0 : 1
  triggers   = [for m in local.modules : m.hash]
  providers = {
    ssh      = ssh
    ignition = ignition
  }

  hostname = var.hostname
  server   = var.k8s.server
  ca_hash  = var.k8s.ca_hash
  ssh      = var.ssh
}

locals {
  modules_with_join = concat(local.modules, [
    for m in [
      var.k8s == null ? null : module.k8s_join[0]
    ] : m if m != null
  ])
}

data "ignition_config" "merged" {
  depends_on = [module.base, module.mounts, module.wireguard, module.k8s_install, module.k8s_join]
  dynamic "merge" {
    for_each = [for m in local.modules_with_join : m.config]
    content {
      source = "data:text/plain;charset=utf-8;base64,${base64encode(jsonencode(merge.value))}"
    }
  }
}
