dependency "metal" {
  config_path = "${get_terragrunt_dir()}/../../../metal"
}

dependency "cilium" {
  config_path = "${get_terragrunt_dir()}/../../system/cilium"
  mock_outputs = {
    gateway_namespace = ""
    gateway_name      = ""
  }
}

dependency "coredns" {
  config_path = "${get_terragrunt_dir()}/../../system/coredns"
  mock_outputs = {
    domains = {
      tesseract_sh = ""
    }
  }
}

dependency "local_path_provisioner" {
  config_path = "${get_terragrunt_dir()}/../../system/local_path_provisioner"
  mock_outputs = {
    storage_classes = {
      media_fast = {
        id = ""
      }
      media_slow = {
        id = ""
      }
    }
  }
}

locals {
  plex = {
    name    = "plex"
    version = "latest"
  }
}

inputs = {
  kube_config_path = dependency.metal.outputs.kube_config_path
  namespace        = "media"
  gateway = {
    name      = dependency.cilium.outputs.gateway_name
    namespace = dependency.cilium.outputs.gateway_namespace
  }
  plex = {
    name   = local.plex.name
    image  = "lscr.io/linuxserver/plex:${local.plex.version}"
    domain = "plex.${dependency.coredns.outputs.domains.tesseract_sh}"
    ip     = "10.42.0.32"
    labels = {
      "app.kubernetes.io/name"       = local.plex.name
      "app.kubernetes.io/instance"   = local.plex.name
      "app.kubernetes.io/managed-by" = "Terraform"
      "app.kubernetes.io/version"    = local.plex.version
    }
  }
  timezone                       = "America/New_York"
  plex_config_storage_class_name = dependency.local_path_provisioner.outputs.storage_classes.media_fast.id
  plex_config_quota              = "20Gi"
  movies_storage_class_name      = dependency.local_path_provisioner.outputs.storage_classes.media_slow.id
  movies_quota                   = "20Ti"
  tvshows_storage_class_name     = dependency.local_path_provisioner.outputs.storage_classes.media_slow.id
  tvshows_quota                  = "20Ti"
}