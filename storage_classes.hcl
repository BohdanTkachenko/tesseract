locals {
  types = {
    fast = "/var/lib/volumes"
    slow = "/mnt/hdd/volumes"
  }

  storage_classes = [
    { namespace = "media", type = "fast" },
    { namespace = "media", type = "slow" },

    { namespace = "stash", type = "fast" },
    { namespace = "stash", type = "slow" },
  ]
}

inputs = {
  for storage_class in local.storage_classes :
  "${storage_class.namespace}_${storage_class.type}" => {
    id   = "${replace(storage_class.namespace, "_", "-")}-${storage_class.type}-local"
    path = "${local.types[storage_class.type]}/${storage_class.namespace}"
  }
}
