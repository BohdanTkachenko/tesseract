locals {
  fast = "/var/lib/volumes"
  slow = "/var/mnt/hdd/volumes"

  storage_classes = {
    media_fast = "${local.fast}/media"
    media_slow = "${local.slow}/media"
    stash_fast = "${local.fast}/stash"
    stash_slow = "${local.slow}/media"
  }
}

inputs = {
  for key, path in local.storage_classes : key => {
    id   = "${replace(key, "_", "-")}-local"
    path = path
  }
}
