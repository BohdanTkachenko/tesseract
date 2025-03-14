variable "ssh" {
  description = "Main node SSH connection details."
  sensitive   = true
  type = object({
    agent               = bool
    host                = string
    port                = number
    user                = string
    password            = string
    private_key         = string
    bastion_host        = string
    bastion_port        = number
    bastion_user        = string
    bastion_password    = string
    bastion_private_key = string
  })
  default = {
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

variable "node_name" {
  type    = string
  default = "tesseract.sh"
}

variable "api_server" {
  type    = string
  default = "https://tesseract.sh:6443"
}

variable "remote_kubeconfig_path" {
  type    = string
  default = "$HOME/.kube/config"
}

variable "remote_admin_kubeconfig_path" {
  type    = string
  default = "/etc/kubernetes/admin.conf"
}

variable "remote_clusterconfig_path" {
  type    = string
  default = "/var/lib/terraform/kubernetes-clusterconfig.yaml"
}

variable "remote_ca_path" {
  type    = string
  default = "/etc/kubernetes/pki/ca.crt"
}

variable "local_ca_path" {
  type    = string
  default = "~/.kube/ca.crt"
}

variable "local_key_path" {
  type    = string
  default = "~/.kube/kube.key"
}

variable "local_csr_path" {
  type    = string
  default = "~/.kube/kube.csr"
}

variable "local_crt_path" {
  type    = string
  default = "~/.kube/kube.crt"
}

variable "local_kubeconfig_path" {
  type    = string
  default = "~/.kube/config"
}
