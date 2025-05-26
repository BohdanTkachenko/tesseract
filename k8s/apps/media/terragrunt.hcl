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

inputs = {
  kube_config_path               = dependency.metal.outputs.kube_config_path
  gateway_namespace              = dependency.cilium.outputs.gateway_namespace
  gateway_name                   = dependency.cilium.outputs.gateway_name
  namespace                      = "media"
  timezone                       = "America/New_York"
  plex_domain                    = "plex.${dependency.coredns.outputs.domains.tesseract_sh}"
  plex_ip                        = "10.42.0.32"
  plex_config_storage_class_name = dependency.local_path_provisioner.outputs.storage_classes.media_fast.id
  plex_config_quota              = "20Gi"
  movies_storage_class_name      = dependency.local_path_provisioner.outputs.storage_classes.media_slow.id
  movies_quota                   = "20Ti"
  tvshows_storage_class_name     = dependency.local_path_provisioner.outputs.storage_classes.media_slow.id
  tvshows_quota                  = "20Ti"
}