resource "kubernetes_deployment" "local-path-provisioner" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = var.labels
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app.kubernetes.io/name"     = var.labels["app.kubernetes.io/name"]
        "app.kubernetes.io/instance" = var.labels["app.kubernetes.io/instance"]
      }
    }
    template {
      metadata {
        labels = var.labels
      }
      spec {
        service_account_name = resource.kubernetes_service_account.local_path_provisioner.metadata[0].name
        container {
          name              = var.name
          image             = var.image
          image_pull_policy = "IfNotPresent"
          command = [
            "local-path-provisioner",
            "--debug",
            "start",
            "--config",
            "/etc/config/config.json",
            "--service-account-name",
            resource.kubernetes_service_account.local_path_provisioner.metadata[0].name,
            "--provisioner-name",
            var.provisioner_name,
            "--helper-image",
            "busybox:latest",
            "--configmap-name",
            "local-path-config",
          ]
          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/config/"
          }
          env {
            name  = "POD_NAMESPACE"
            value = var.namespace
          }
          env {
            name  = "CONFIG_MOUNT_PATH"
            value = "/etc/config/"
          }
        }
        volume {
          name = "config-volume"
          config_map {
            name         = "local-path-config"
            default_mode = "0644"
          }
        }
      }
    }
  }
}
