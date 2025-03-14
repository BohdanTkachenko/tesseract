resource "kubernetes_config_map_v1_data" "local_path_config" {
  depends_on = [helm_release.local_path_provisioner]
  metadata {
    name      = "local-path-config"
    namespace = var.namespace
  }
  force = true
  data = {
    "helperPod.yaml" = "${file("${path.module}/helper_pod.yaml")}"
  }
}
