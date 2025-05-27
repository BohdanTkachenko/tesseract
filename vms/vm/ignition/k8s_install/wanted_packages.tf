data "ignition_file" "yum_repo_kubernetes" {
  path = "/etc/yum.repos.d/kubernetes.repo"
  contents {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(
      templatefile("${path.module}/contents/files/etc/yum.repos.d/kubernetes.repo", {
        k8s_version = var.k8s_version
      })
    )}"
  }
}

data "ignition_file" "dnf_module_cri_o" {
  path = "/etc/dnf/modules.d/cri-o.module"
  contents {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(
      templatefile("${path.module}/contents/files/etc/dnf/modules.d/cri-o.module", {
        k8s_version = var.k8s_version
      })
    )}"
  }
}

data "ignition_file" "wanted_packages" {
  path = "/etc/rpm/packages.wants/k8s"
  contents {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(
      join("\n", [
        "cri-o",
        "kubelet",
        "kubeadm",
        "kubectl",
      ])
    )}"
  }
}
