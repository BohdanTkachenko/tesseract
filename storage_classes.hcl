locals {
  fast_path = "/var/lib/volumes/"
  slow_path = "/var/mnt/hdd/volumes/"

  storage_classes = {
    media_fast = fast_path.local + "media"
    media_slow = slow_path.local + "media"
    stash_fast = fast_path.local + "stash"
    stash_slow = slow_path.local + "stash"
  }
}

inputs = {
  for key, path in storage_classes : key => {
    id   = replace(name, "_", "-") + "-local"
    path = path
  }
}
