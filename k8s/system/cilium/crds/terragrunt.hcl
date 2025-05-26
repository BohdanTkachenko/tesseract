dependency "metal" {
  config_path = "${get_terragrunt_dir()}/../../../../metal"
}

inputs = {
  kube_config_path = dependency.metal.outputs.kube_config_path
}