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


data "ignition_file" "wanted_package_cri_o" {
  path = "/etc/rpm/packages.wants/cri-o"
  contents {
    source = "data:,"
  }
}

data "ignition_file" "wanted_package_kubelet" {
  path = "/etc/rpm/packages.wants/kubelet"
  contents {
    source = "data:,"
  }
}

data "ignition_file" "wanted_package_kubeadm" {
  path = "/etc/rpm/packages.wants/kubeadm"
  contents {
    source = "data:,"
  }
}

data "ignition_file" "wanted_package_kubectl" {
  path = "/etc/rpm/packages.wants/kubectl"
  contents {
    source = "data:,"
  }
}
