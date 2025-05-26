variable "kube_config_path" {
  type = string
}

variable "namespace" {
  type = string
}

variable "gateway_namespace" {
  type = string
}

variable "gateway_name" {
  type = string
}

variable "stash_domain" {
  type = string
}

variable "stash_ip" {
  type = string
}

variable "stash_config_storage_class_name" {
  type = string
}

variable "stash_config_quota" {
  type = string
}

variable "stash_metadata_storage_class_name" {
  type = string
}

variable "stash_metadata_quota" {
  type = string
}

variable "stash_cache_storage_class_name" {
  type = string
}

variable "stash_cache_quota" {
  type = string
}

variable "stash_blobs_storage_class_name" {
  type = string
}

variable "stash_blobs_quota" {
  type = string
}

variable "stash_generated_storage_class_name" {
  type = string
}

variable "stash_generated_quota" {
  type = string
}

variable "videos_storage_class_name" {
  type = string
}

variable "videos_quota" {
  type = string
}

variable "images_storage_class_name" {
  type = string
}

variable "images_quota" {
  type = string
}

variable "vaultwarden_storage_class_name" {
  type = string
}

variable "vaultwarden_quota" {
  type = string
}
