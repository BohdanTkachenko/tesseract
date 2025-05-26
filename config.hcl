locals {
  storage_classes = read_terragrunt_config("./storage_classes.hcl").inputs
  vms             = read_terragrunt_config("./vms.hcl").inputs
}

inputs = {
  ssh = {
    host = "tesseract.lan"
    port = 22
    initial_setup = {
      username         = "dan"
      private_key_path = ""
    }
    service_account = {
      username                = "terraform"
      target_private_key_path = "~/.ssh/terraform_service_account_key"
    }
  }

  host = {
    hostname = "tesseract.sh"
    network = {
      interface    = "enp3s0"
      ipv4_address = "10.42.0.1"
      nameserver   = "10.0.0.1"
    }
  }

  k8s = {
    version    = "1.32"
    api_server = "https://tesseract.sh:6443"
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

    storage_classes = {
      for key, value in local.storage_classes : value.id => {
        path = value.path
        nodes = [
          for name, node in local.vms : name
          if contains(node.mounts, value.path)
        ]
      }
    }
  }

  vm_base_fcos_image_remote = {
    stream_url   = "https://builds.coreos.fedoraproject.org/streams/stable.json"
    architecture = "x86_64"
    platform     = "qemu"
    format       = "qcow2.xz"
    local_dir    = "/tmp"
  }

  vms = local.vms
}