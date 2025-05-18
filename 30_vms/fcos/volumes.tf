data "http" "fcos_stream" {
  url = var.fcos.stream_url
}

locals {
  fcos_remote_image = jsondecode(data.http.fcos_stream.response_body).architectures[var.fcos.architecture].artifacts[var.fcos.platform].formats[var.fcos.format].disk
}

resource "shell_script" "fcos_image" {
  depends_on = [data.http.fcos_stream]

  lifecycle_commands {
    create = file("${path.module}/scripts/download_file.sh")
    update = file("${path.module}/scripts/download_file.sh")
    read   = file("${path.module}/scripts/verify_file.sh")
    delete = <<-EOT
      rm -rf "$COMPRESSED_LOCAL_PATH" "$UNCOMPRESSED_LOCAL_PATH"
    EOT
  }

  environment = {
    SCRIPT_DIR              = "${path.module}/scripts"
    REMOTE_URL              = "${local.fcos_remote_image.location}"
    COMPRESSED_LOCAL_PATH   = "${var.fcos.local_dir}/${basename(local.fcos_remote_image.location)}"
    COMPRESSED_SHA256_SUM   = local.fcos_remote_image.sha256
    UNCOMPRESSED_LOCAL_PATH = "${var.fcos.local_dir}/${trimsuffix(basename(local.fcos_remote_image.location), ".xz")}"
    UNCOMPRESSED_SHA256_SUM = local.fcos_remote_image["uncompressed-sha256"]
  }
}

resource "libvirt_volume" "fcos" {
  depends_on = [resource.shell_script.fcos_image]
  name       = "fedora-coreos.qcow2"
  pool       = var.pool_name
  source     = resource.shell_script.fcos_image.output.path
  format     = "qcow2"
}
