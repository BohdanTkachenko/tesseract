data "http" "ciliuml2announcementpolicies_crd_spec" {
  url = "https://raw.githubusercontent.com/cilium/cilium/v1.17.1/pkg/k8s/apis/cilium.io/client/crds/v2alpha1/ciliuml2announcementpolicies.yaml"
}

resource "kubernetes_manifest" "ciliuml2announcementpolicies_crd" {
  manifest = yamldecode(data.http.ciliuml2announcementpolicies_crd_spec.response_body)
}
