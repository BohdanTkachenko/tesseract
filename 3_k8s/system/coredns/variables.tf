variable "namespace" {
  type = string
}

variable "dns_ip" {
  type = string
}

variable "gateway_ip" {
  type = string
}

variable "domains" {
  type = list(string)
}
