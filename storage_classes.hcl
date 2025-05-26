locals {
  fast_base_dir = "/var/lib/volumes"
  slow_base_dir = "/mnt/hdd/volumes"

  storage_classes = {
    media_fast = local.fast_base_dir
    media_slow = local.slow_base_dir
  }
}

inputs = {
  for key, value in local.storage_classes : key => {
    id   = "${replace(key, "_", "-")}-local"
    path = "${value}/${key}"
  }
}
