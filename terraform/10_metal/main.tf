resource "ssh_sensitive_resource" "k8s_init" {
  file {
    source      = "${path.module}/clusterconfig.yaml"
    destination = var.remote_clusterconfig_path
    permissions = "0660"
  }

  commands = [
    "sudo /usr/bin/kubeadm init --config=\"${var.remote_clusterconfig_path}\"",
  ]

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

resource "ssh_sensitive_resource" "k8s_reset" {
  when = "destroy"

  commands = [
    "sudo /usr/bin/kubeadm reset -f",
    "sudo /usr/sbin/ipvsadm --clear",
    "rm -rf \"${var.remote_clusterconfig_path}\"",
  ]

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
