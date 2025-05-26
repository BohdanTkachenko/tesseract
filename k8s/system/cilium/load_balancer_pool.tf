resource "kubectl_manifest" "pool" {
  depends_on = [helm_release.cilium]
  yaml_body = yamlencode({
    "apiVersion" = "cilium.io/v2alpha1"
    "kind"       = "CiliumLoadBalancerIPPool"
    "metadata" = {
      "name" = "load-balancer-pool"
    }
    "spec" = {
      "blocks" = [
        { "cidr" = var.loadbalancer_ipv4_network },
        { "cidr" = var.loadbalancer_ipv6_network }
      ]
    }
  })
}
