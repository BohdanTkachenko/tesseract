variable "kube_config_path" {
  type = string
}

variable "namespace" {
  type = string
}

variable "timezone" {
  type = string
}

variable "volumes" {
  type = map(object({
    name          = string
    labels        = map(string)
    storage_class = string
    access_modes  = list(string)
    quota         = string
  }))
}

variable "gateway" {
  type = object({
    name      = string
    namespace = string
  })
}

variable "plex" {
  type = object({
    name        = string
    labels      = map(string)
    node_labels = map(string)
    image       = string
    domain      = string
    ip          = string
  })
}
