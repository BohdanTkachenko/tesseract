
data "ignition_file" "join_config" {
  path = "/etc/kubernetes/join-config.yaml"
  contents {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(
      templatefile("${path.module}/contents/files/etc/kubernetes/join-config.yaml", {
        k8s_server  = trimspace(var.server)
        k8s_ca_hash = trimspace(var.ca_hash)
        k8s_token   = trimspace(ssh_sensitive_resource.k8s_create_token.result)
      })
    )}"
  }
}
