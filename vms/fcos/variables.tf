variable "fcos" {
  type = object({
    version      = number
    stream_url   = string
    architecture = string
    platform     = string
    format       = string
    local_dir    = string
  })
}

variable "pool_name" {
  type = string
}

