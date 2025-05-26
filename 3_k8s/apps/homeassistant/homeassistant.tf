locals {
  name = "homeassistant"
}

resource "kubernetes_service" "homeassistant" {
  metadata {
    namespace = var.namespace
    name      = local.name
    labels = {
      "app.kubernetes.io/name" = local.name
    }
  }
  spec {
    selector = {
      "app.kubernetes.io/name" = local.name
    }
    port {
      name        = "http"
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_endpoint_slice_v1" "homeassistant" {
  metadata {
    namespace = var.namespace
    name      = local.name
    labels = {
      "app.kubernetes.io/name" = local.name
      "kubernetes.io/service-name" : local.name
      "endpointslice.kubernetes.io/managed-by" : "cluster-admins"
    }
  }
  address_type = "IPv4"
  endpoint {
    addresses = [var.homeassistant_address]
  }
  port {
    name         = "http"
    app_protocol = "TCP"
    port         = 80
  }
}
