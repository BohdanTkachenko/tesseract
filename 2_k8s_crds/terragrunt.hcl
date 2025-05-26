dependency "metal" {
  config_path = "../1_metal"
}

inputs = {
  kube_config_path = dependency.metal.outputs.kube_config_path
}