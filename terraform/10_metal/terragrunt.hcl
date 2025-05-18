inputs = {
  node_name                    = "tesseract.sh"
  api_server                   = "https://tesseract.sh:6443"
  remote_kubeconfig_path       = "$HOME/.kube/config"
  remote_admin_kubeconfig_path = "/etc/kubernetes/admin.conf"
  remote_clusterconfig_path    = "/var/lib/terraform/kubernetes-clusterconfig.yaml"
  remote_ca_path               = "/etc/kubernetes/pki/ca.crt"
  remote_resolv_conf_path      = "/etc/resolv.kubelet.conf"
  nameserver                   = "10.0.0.1"
  local_ca_path                = "~/.kube/ca.crt"
  local_key_path               = "~/.kube/kube.key"
  local_csr_path               = "~/.kube/kube.csr"
  local_crt_path               = "~/.kube/kube.crt"
  local_kubeconfig_path        = "~/.kube/config"
  ssh = {
    agent               = false
    host                = "tesseract.lan"
    port                = 22
    user                = "terraform"
    password            = null
    private_key         = "~/.ssh/terraform"
    bastion_host        = null
    bastion_port        = null
    bastion_user        = null
    bastion_password    = null
    bastion_private_key = null
  }
}