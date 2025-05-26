dependency "create_tls_key" {
  config_path = "./create_tls_key"
}

dependency "generate_script" {
  config_path = "./generate_script"
}

locals {
  config    = read_terragrunt_config(find_in_parent_folders("config.hcl")).inputs
  lock_file = ".service-account-created.lock"
}

terraform {
  before_hook "create_service_account" {
    if       = !fileexists(local.lock_file)
    commands = ["apply"]
    execute = [
      "bash",
      "./scripts/local_run_remote_create_service_account.sh",
      local.lock_file,
      local.config.ssh.host,
      local.config.ssh.port,
      local.config.ssh.initial_setup.username,
      local.config.ssh.initial_setup.private_key_path,
      dependency.generate_script.outputs.create_service_account,
    ]
  }
}

inputs = {
  ssh_host         = local.config.ssh.host
  ssh_port         = local.config.ssh.port
  public_key       = dependency.create_tls_key.outputs.key.public_key_openssh
  private_key      = dependency.create_tls_key.outputs.key.private_key_openssh
  private_key_path = local.config.ssh.service_account.target_private_key_path
  username         = dependency.generate_script.outputs.username,
}
