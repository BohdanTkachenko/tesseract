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

inputs = {
  kube_config_path  = dependency.metal.outputs.kube_config_path
  gateway_namespace = dependency.cilium.outputs.gateway_namespace
  gateway_name      = dependency.cilium.outputs.gateway_name
  namespace         = "whoami"
  whoami_domain     = "whoami.${dependency.coredns.outputs.domains.tesseract_sh}"
}