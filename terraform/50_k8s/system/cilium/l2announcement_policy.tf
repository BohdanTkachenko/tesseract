resource "kubectl_manifest" "l2announcement_policy" {
  depends_on = [helm_release.cilium]
  yaml_body = yamlencode({
    "apiVersion" = "cilium.io/v2alpha1"
    "kind"       = "CiliumL2AnnouncementPolicy"
    "metadata" = {
      "name" = "l2announcement-policy"
    }
    "spec" = {
      "externalIPs"     = true
      "loadBalancerIPs" = true
      "interfaces"      = [var.network_interface]
    }
  })
}
