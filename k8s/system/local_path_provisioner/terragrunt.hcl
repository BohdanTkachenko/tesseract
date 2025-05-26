dependency "metal" {
  config_path = "${get_terragrunt_dir()}/../../../metal"
}

dependency "cilium" {
  config_path = "${get_terragrunt_dir()}/../cilium"
  mock_outputs = {
    gateway_namespace = ""
    gateway_name      = ""
  }
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("config.hcl")).inputs
}

inputs = {
  kube_config_path = dependency.metal.outputs.kube_config_path
  namespace        = "kube-local-path-storage"
  storage_classes  = local.config.k8s.storage_classes
}