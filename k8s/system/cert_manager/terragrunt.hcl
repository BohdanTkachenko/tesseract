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
  config      = read_terragrunt_config(find_in_parent_folders("config.hcl")).inputs
  secret_vars = yamldecode(sops_decrypt_file(find_in_parent_folders("secrets.yaml")))
}

inputs = {
  kube_config_path     = dependency.metal.outputs.kube_config_path
  namespace            = "kube-cert-manager"
  letsencrypt_email    = local.config.k8s.cert_manager.admin_email
  cloudflare_api_token = local.secret_vars.cert_manager_cloudflare_api_token
}