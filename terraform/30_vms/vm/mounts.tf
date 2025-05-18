resource "ssh_sensitive_resource" "create_host_storage_dir" {
  for_each = var.mounts

  commands = ["sudo mkdir -p '${each.key}'"]

  agent               = var.ssh.agent
  host                = var.ssh.host
  port                = var.ssh.port
  user                = var.ssh.user
  password            = var.ssh.password
  private_key         = var.ssh.private_key
  bastion_host        = var.ssh.bastion_host
  bastion_port        = var.ssh.bastion_port
  bastion_user        = var.ssh.bastion_user
  bastion_password    = var.ssh.bastion_password
  bastion_private_key = var.ssh.bastion_private_key
}
