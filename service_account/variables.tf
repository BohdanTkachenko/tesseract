variable "ssh_host" {
  type = string
}

variable "ssh_port" {
  type = number
}

variable "public_key" {
  type = string
}

variable "private_key" {
  sensitive = true
  type      = string
}

variable "private_key_path" {
  type = string
}

variable "username" {
  type = string
}
