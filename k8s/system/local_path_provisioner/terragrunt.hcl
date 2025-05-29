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
  config  = read_terragrunt_config(find_in_parent_folders("config.hcl")).inputs
  name    = "local-path-provisioner"
  version = "pr-499-1"
}

inputs = {
  kube_config_path = dependency.metal.outputs.kube_config_path
  main_node_name   = config.host.hostname
  namespace        = "kube-local-path-storage"
  name             = local.name
  labels = {
    "app.kubernetes.io/name"       = local.name
    "app.kubernetes.io/instance"   = local.name
    "app.kubernetes.io/managed-by" = "Terraform"
    "app.kubernetes.io/version"    = local.version
  }
  image            = "ghcr.io/bohdantkachenko/local-path-provisioner:${local.version}"
  provisioner_name = "cluster.local/local-path-provisioner"
  storage_classes  = config.k8s.storage_classes
}