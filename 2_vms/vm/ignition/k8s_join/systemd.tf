data "ignition_systemd_unit" "k8s_join_cluster" {
  name    = "k8s-join-cluster.service"
  content = file("${path.module}/contents/systemd/k8s-join-cluster.service")
}
