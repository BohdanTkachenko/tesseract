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
      stash_fast = {
        id = ""
      }
      stash_slow = {
        id = ""
      }
    }
  }
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("config.hcl")).inputs
}

inputs = {
  kube_config_path                   = local.config.k8s.local.kubeconfig_path
  gateway_namespace                  = dependency.cilium.outputs.gateway_namespace
  gateway_name                       = dependency.cilium.outputs.gateway_name
  namespace                          = "stash"
  stash_domain                       = "stash.${dependency.coredns.outputs.domains.tesseract_sh}"
  stash_ip                           = "10.42.0.69"
  stash_config_storage_class_name    = dependency.local_path_provisioner.outputs.storage_classes.stash_fast.id
  stash_config_quota                 = "100Mi"
  stash_metadata_storage_class_name  = dependency.local_path_provisioner.outputs.storage_classes.stash_fast.id
  stash_metadata_quota               = "1Gi"
  stash_cache_storage_class_name     = dependency.local_path_provisioner.outputs.storage_classes.stash_fast.id
  stash_cache_quota                  = "1Gi"
  stash_blobs_storage_class_name     = dependency.local_path_provisioner.outputs.storage_classes.stash_fast.id
  stash_blobs_quota                  = "10Gi"
  stash_generated_storage_class_name = dependency.local_path_provisioner.outputs.storage_classes.stash_fast.id
  stash_generated_quota              = "200Gi"
  videos_storage_class_name          = dependency.local_path_provisioner.outputs.storage_classes.stash_slow.id
  videos_quota                       = "5Ti"
  images_storage_class_name          = dependency.local_path_provisioner.outputs.storage_classes.stash_slow.id
  images_quota                       = "10Gi"
  vaultwarden_storage_class_name     = dependency.local_path_provisioner.outputs.storage_classes.stash_fast.id
  vaultwarden_quota                  = "100Mi"
}
