variable "kube_config_path" {
  type = string
}

variable "namespace" {
  type = string
}

variable "network_interface" {
  type = string
}

variable "cluster_ipv4_network" {
  type = string
}

variable "cluster_ipv6_network" {
  type = string
}

variable "loadbalancer_ipv4_network" {
  type = string
}

variable "loadbalancer_ipv6_network" {
  type = string
}

variable "host_ip" {
  type = string
}

variable "gateway_name" {
  type = string
}

variable "gateway_ip" {
  type = string
}

variable "domains" {
  type = list(string)
}
