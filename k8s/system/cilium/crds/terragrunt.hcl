include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("config.hcl")).inputs
}

inputs = {
  kube_config_path = local.config.k8s.local.kubeconfig_path
}
