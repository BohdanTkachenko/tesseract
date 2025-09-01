locals {
  storage_classes = read_terragrunt_config("./storage_classes.hcl").inputs
  vms             = read_terragrunt_config("./vms.hcl").inputs
}

inputs = {
  host = {
    hostname = "tesseract.sh"
    timezone = "America/New_York"
    network = {
      interface    = "enp3s0"
      ipv4_address = "10.42.0.1"
      nameserver   = "10.0.0.1"
    }
  }

  libvirt_connection_string = "qemu+tls://10.42.0.1/system"

  k8s = {
    version    = "1.32"
    control_plane_node_name = "tesseract"
    api_server = "https://10.42.0.1:6443"

    remote = {
      kubeconfig_path       = "$HOME/.kube/config"
      admin_kubeconfig_path = "/etc/kubernetes/admin.conf"
      clusterconfig_path    = "/var/lib/terraform/kubernetes-clusterconfig.yaml"
      ca_path               = "/etc/kubernetes/pki/ca.crt"
      resolv_conf_path      = "/etc/resolv.kubelet.conf"
    }

    local = {
      ca_path         = "~/.kube/ca.crt"
      key_path        = "~/.kube/kube.key"
      csr_path        = "~/.kube/kube.csr"
      crt_path        = "~/.kube/kube.crt"
      kubeconfig_path = "~/.kube/config"
    }

    network = {
      cluster = {
        ipv4 = "10.244.0.0/16"
        ipv6 = "fd42:1ee7::/104"
      }
      loadbalancer = {
        ipv4 = "10.42.0.0/24"
        ipv6 = "fd42:c0de::/112"
      }
    }

    gateway = {
      ipv4_address = "10.42.0.80"
      domains      = ["tesseract.sh", "cyber.place"]
    }

    cert_manager = {
      admin_email = "dan@cyber.place"
    }

    local_dns_ipv4 = "10.42.0.53"

    storage_classes = local.storage_classes

    default_labels = {
      "app.kubernetes.io/managed-by" = "Terraform"
    }
  }

  vm_base_fcos_image_remote = {
    version      = 42
    stream_url   = "https://builds.coreos.fedoraproject.org/streams/stable.json"
    architecture = "x86_64"
    platform     = "qemu"
    format       = "qcow2.xz"
    local_dir    = "/tmp"
  }

  vms = local.vms
}