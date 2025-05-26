output "k8s_certificate_authority" {
  depends_on = [ssh_resource.get_certificate_authority]
  value      = resource.ssh_resource.get_certificate_authority.result
}

output "k8s_certificate_authority_file" {
  depends_on = [shell_script.certificate_authority]
  value      = local.local_ca_path
}

output "k8s_certificate_authority_hash" {
  depends_on = [data.shell_script.k8s_info]
  value      = data.shell_script.k8s_info.output.ca_hash
}

output "k8s_server" {
  depends_on = [data.shell_script.k8s_info]
  value      = data.shell_script.k8s_info.output.server
}

output "kube_config_path" {
  depends_on = [shell_script.kubeconfig]
  value      = local.local_kubeconfig_path
}
