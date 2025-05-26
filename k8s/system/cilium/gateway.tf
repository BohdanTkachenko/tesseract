resource "kubectl_manifest" "gateway" {
  depends_on = [helm_release.cilium]
  yaml_body = yamlencode({
    "apiVersion" = "gateway.networking.k8s.io/v1"
    "kind"       = "Gateway"
    "metadata" = {
      "name"      = var.gateway_name
      "namespace" = var.namespace
      annotations = {
        "cert-manager.io/cluster-issuer" = "letsencrypt"
      }
    }
    "spec" = {
      "gatewayClassName" = "cilium"
      "addresses" = [
        {
          "type"  = "IPAddress"
          "value" = var.gateway_ip
        }
      ]
      "listeners" = concat(
        [
          {
            "name"     = "http"
            "protocol" = "HTTP"
            "port"     = 80
            "hostname" = var.gateway_ip
            "allowedRoutes" = {
              "namespaces" = {
                "from" = "All"
              }
            }
          }
        ],
        [for item in [
          for domain in var.domains : {
            "domain"     = lower(domain)
            "safeDomain" = replace(lower(domain), "/[^a-z0-9\\-]/", "-")
          }
          ] : [
          {
            "name"     = "http-${item.safeDomain}"
            "protocol" = "HTTP"
            "port"     = 80
            "hostname" = item.domain
            "allowedRoutes" = {
              "namespaces" = {
                "from" = "All"
              }
            }
          },
          {
            "name"     = "http-${item.safeDomain}-wildcard"
            "protocol" = "HTTP"
            "port"     = 80
            "hostname" = "*.${item.domain}"
            "allowedRoutes" = {
              "namespaces" = {
                "from" = "All"
              }
            }
          },
          {
            "name"     = "https-${item.safeDomain}"
            "protocol" = "HTTPS"
            "port"     = 443
            "hostname" = item.domain
            "allowedRoutes" = {
              "namespaces" = {
                "from" = "All"
              }
            }
            "tls" = {
              "certificateRefs" = [
                {
                  "kind" = "Secret"
                  "name" = "${item.safeDomain}-tls"
                }
              ]
            }
          },
          {
            "name"     = "https-${item.safeDomain}-wildcard"
            "protocol" = "HTTPS"
            "port"     = 443
            "hostname" = "*.${item.domain}"
            "allowedRoutes" = {
              "namespaces" = {
                "from" = "All"
              }
            }
            "tls" = {
              "certificateRefs" = [
                {
                  "kind" = "Secret"
                  "name" = "${item.safeDomain}-tls"
                }
              ]
            }
          }
        ]]...
      )
    }
  })
}
