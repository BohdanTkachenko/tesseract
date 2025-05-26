variable "namespace" {
  type = string
}

variable "storage_classes" {
  type = map(object({
    path  = string
    nodes = list(string)
  }))
}
