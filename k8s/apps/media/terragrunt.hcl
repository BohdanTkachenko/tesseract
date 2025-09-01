include "root" {
  path = find_in_parent_folders("root.hcl")
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
  config = read_terragrunt_config(find_in_parent_folders("config.hcl")).inputs
  plex = {
    name    = "plex"
    image   = "plexinc/pms-docker"
    version = "latest"
  }
}

inputs = {
  kube_config_path = local.config.k8s.local.kubeconfig_path
  namespace        = "media"
  timezone         = local.config.host.timezone

  volumes = {
    plex_config = {
      name          = "plex-config"
      labels        = local.config.k8s.default_labels
      storage_class = dependency.local_path_provisioner.outputs.storage_classes.media_fast.id
      access_modes  = ["ReadWriteOnce"]
      quota         = "20Gi"
    }
    movies = {
      name          = "movies"
      labels        = local.config.k8s.default_labels
      storage_class = dependency.local_path_provisioner.outputs.storage_classes.media_slow.id
      access_modes  = ["ReadWriteMany"]
      quota         = "20Ti"
    }
    tvshows = {
      name          = "tvshows"
      labels        = local.config.k8s.default_labels
      storage_class = dependency.local_path_provisioner.outputs.storage_classes.media_slow.id
      access_modes  = ["ReadWriteMany"]
      quota         = "20Ti"
    }
  }

  gateway = {
    name      = dependency.cilium.outputs.gateway_name
    namespace = dependency.cilium.outputs.gateway_namespace
  }

  plex = {
    name = local.plex.name
    labels = merge(local.config.k8s.default_labels, {
      "app.kubernetes.io/name"     = local.plex.name
      "app.kubernetes.io/instance" = local.plex.name
      "app.kubernetes.io/version"  = local.plex.version
    })
    node_labels = local.config.vms.gpu.labels
    image       = "${local.plex.image}:${local.plex.version}"
    domain      = "plex.${dependency.coredns.outputs.domains.tesseract_sh}"
    ip          = "10.42.0.32"
  }
}
