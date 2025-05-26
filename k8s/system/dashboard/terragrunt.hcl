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

inputs = {
  kube_config_path = dependency.metal.outputs.kube_config_path
  namespace        = "kube-dashboard"
}