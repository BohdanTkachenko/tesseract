data "ignition_systemd_unit" "mount" {
  for_each = var.mounts

  name = "${each.key}.mount"
  content = templatefile("${path.module}/contents/systemd/tpl.mount", {
    type   = "virtiofs"
    source = each.key
    target = each.value
  })
}
