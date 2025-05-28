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
  version = "v0.0.31"
}

inputs = {
  kube_config_path = dependency.metal.outputs.kube_config_path
  namespace        = "kube-local-path-storage"
  name             = local.name
  labels = {
    "app.kubernetes.io/name"       = local.name
    "app.kubernetes.io/instance"   = local.name
    "app.kubernetes.io/managed-by" = "Terraform"
    "app.kubernetes.io/version"    = local.version
  }
  image            = "rancher/local-path-provisioner:${local.version}"
  provisioner_name = "cluster.local/local-path-provisioner"
  storage_classes  = local.config.k8s.storage_classes
}