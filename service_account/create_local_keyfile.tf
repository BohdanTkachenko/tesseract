resource "local_sensitive_file" "private_key" {
  content  = var.private_key
  filename = pathexpand(var.private_key_path)
}
