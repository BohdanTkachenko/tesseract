dependency "service_account_key" {
  config_path = "../create_tls_key"
}

locals {
  config = read_terragrunt_config(find_in_parent_folders("config.hcl")).inputs
}

inputs = {
  public_key = dependency.service_account_key.outputs.key.public_key_openssh
  username   = local.config.ssh.service_account.username
}
