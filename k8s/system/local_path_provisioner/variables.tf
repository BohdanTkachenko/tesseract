variable "kube_config_path" {
  type = string
}

variable "main_node_name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "name" {
  type = string
}

variable "labels" {
  type = map(string)
}

variable "image" {
  type = string
}

variable "provisioner_name" {
  type = string
}

variable "storage_classes" {
  type = map(object({
    id   = string
    path = string
  }))
}
