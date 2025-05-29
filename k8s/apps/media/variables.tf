variable "kube_config_path" {
  type = string
}

variable "namespace" {
  type = string
}

variable "plex" {
  type = object({
    name   = string
    labels = map(string)
    image  = string
    domain = string
    ip     = string
  })
}

variable "gateway" {
  type = object({
    name      = string
    namespace = string
  })
}

variable "timezone" {
  type = string
}

variable "plex_config_storage_class_name" {
  type = string
}

variable "plex_config_quota" {
  type = string
}

variable "movies_storage_class_name" {
  type = string
}

variable "movies_quota" {
  type = string
}

variable "tvshows_storage_class_name" {
  type = string
}

variable "tvshows_quota" {
  type = string
}
