data "ignition_config" "config" {
  links = [data.ignition_link.resolv_conf.rendered]
  files = [
    data.ignition_file.yum_repo_kubernetes.rendered,
    data.ignition_file.wanted_package_cri_o.rendered,
    data.ignition_file.wanted_package_kubelet.rendered,
    data.ignition_file.wanted_package_kubeadm.rendered,
    data.ignition_file.wanted_package_kubectl.rendered,
    data.ignition_file.dnf_module_cri_o.rendered,
    data.ignition_file.sysctl_kubernetes.rendered,
  ]
}

output "hash" {
  value = sha256(data.ignition_config.config.rendered)
}

output "config" {
  value = jsondecode(data.ignition_config.config.rendered)
}
