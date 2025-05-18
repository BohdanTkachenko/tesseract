locals {
  mounts = {
    for path in var.mounts :
    replace(trim(path, "/"), "/", "-") => path
  }
}
