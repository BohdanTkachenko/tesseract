variable "ssh" {
  sensitive = true
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
}

variable "node_name" {
  type = string
}

variable "api_server" {
  type = string
}

variable "remote_kubeconfig_path" {
  type = string
}

variable "remote_admin_kubeconfig_path" {
  type = string
}

variable "remote_clusterconfig_path" {
  type = string
}

variable "remote_ca_path" {
  type = string
}

variable "remote_resolv_conf_path" {
  type = string
}

variable "nameserver" {
  type = string
}

variable "local_ca_path" {
  type = string
}

variable "local_key_path" {
  type = string
}

variable "local_csr_path" {
  type = string
}

variable "local_crt_path" {
  type = string
}

variable "local_kubeconfig_path" {
  type = string
}
