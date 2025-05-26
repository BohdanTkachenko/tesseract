output "key" {
  value     = resource.tls_private_key.service_account
  sensitive = true
}
