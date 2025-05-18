output "k8s_certificate_authority" {
  depends_on = [ssh_resource.get_certificate_authority]
  value      = resource.ssh_resource.get_certificate_authority.result
}

output "k8s_certificate_authority_file" {
  depends_on = [shell_script.certificate_authority]
  value      = local.local_ca_path
}
