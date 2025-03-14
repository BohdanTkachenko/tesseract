variable "namespace" {
  type = string
}

variable "timezone" {
  type    = string
  default = "America/New_York"
}

variable "plex_domain" {
  type = string
}

variable "plex_ip" {
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
