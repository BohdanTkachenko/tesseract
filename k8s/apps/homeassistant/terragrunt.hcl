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
      cyber_place = ""
    }
  }
}

inputs = {
  kube_config_path      = dependency.metal.outputs.kube_config_path
  gateway_namespace     = dependency.cilium.outputs.gateway_namespace
  gateway_name          = dependency.cilium.outputs.gateway_name
  namespace             = "homeassistant"
  name                  = "homeassistant"
  homeassistant_domain  = "home.${dependency.coredns.outputs.domains.cyber_place}"
  homeassistant_address = "10.0.0.11"
}