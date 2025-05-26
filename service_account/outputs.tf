output "public_key" {
  value = var.public_key
}

# output "private_key" {
#   sensitive = true
#   value     = var.private_key
# }

# output "private_key_path" {
#   value = local_sensitive_file.private_key.filename
# }

# output "username" {
#   value = var.username
# }

output "ssh_config" {
  sensitive = true
  value = {
    agent               = false
    host                = "tesseract.lan"
    port                = 22
    user                = var.username
    password            = null
    private_key         = var.private_key
    bastion_host        = null
    bastion_port        = null
    bastion_user        = null
    bastion_password    = null
    bastion_private_key = null
  }
}

output "libvirt_ssh_connection_string" {
  sensitive = true
  value     = "qemu+ssh://${var.username}@${var.ssh_host}:${var.ssh_port}/system?sshauth=privkey&keyfile=${local_sensitive_file.private_key.filename}"
}
