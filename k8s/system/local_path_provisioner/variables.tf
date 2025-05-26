variable "kube_config_path" {
  type = string
}

variable "namespace" {
  type = string
}

variable "storage_classes" {
  type = map(object({
    id    = string
    path  = string
    nodes = list(string)
  }))
}
