resource "ssh_sensitive_resource" "k8s_create_token" {
  commands = [
    "sudo /usr/bin/kubeadm token create --ttl 1h --description='New node turnup - ${var.hostname}'",
  ]

  triggers = {
    ignition = jsonencode(var.triggers)
  }

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
