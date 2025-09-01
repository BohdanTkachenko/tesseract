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
      cyber_place = ""
    }
  }
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("config.hcl")).inputs
}

inputs = {
  kube_config_path      = local.config.k8s.local.kubeconfig_path
  gateway_namespace     = dependency.cilium.outputs.gateway_namespace
  gateway_name          = dependency.cilium.outputs.gateway_name
  namespace             = "homeassistant"
  name                  = "homeassistant"
  homeassistant_domain  = "home.${dependency.coredns.outputs.domains.cyber_place}"
  homeassistant_address = "10.0.0.11"
}
