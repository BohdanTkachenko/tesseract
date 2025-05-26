locals {
  local_ca_path         = pathexpand(var.local_ca_path)
  local_key_path        = pathexpand(var.local_key_path)
  local_csr_path        = pathexpand(var.local_csr_path)
  local_crt_path        = pathexpand(var.local_crt_path)
  local_kubeconfig_path = pathexpand(var.local_kubeconfig_path)
}

resource "ssh_resource" "k8s_init" {
  file {
    source      = "${path.module}/clusterconfig.yaml"
    destination = var.remote_clusterconfig_path
    permissions = "0660"
  }

  commands = [
    "echo 'nameserver ${var.nameserver}' | sudo install -m 644 /dev/stdin '${var.remote_resolv_conf_path}'",
    "sudo /usr/bin/kubeadm init --node-name=\"${var.node_name}\" --config=\"${var.remote_clusterconfig_path}\"",
  ]

  agent               = var.ssh.agent
  host                = var.ssh.host
  port                = var.ssh.port
  user                = var.ssh.user
  password            = var.ssh.password
  private_key         = var.ssh.private_key
  bastion_host        = var.ssh.bastion_host
  bastion_port        = var.ssh.bastion_port
  bastion_user        = var.ssh.bastion_user
  bastion_password    = var.ssh.bastion_password
  bastion_private_key = var.ssh.bastion_private_key
}

resource "ssh_resource" "k8s_reset" {
  when = "destroy"

  commands = [
    "sudo rm ${var.remote_resolv_conf_path}",
    "sudo /usr/bin/kubeadm reset -f",
    "sudo /usr/sbin/ipvsadm --clear",
    "rm -rf \"${var.remote_clusterconfig_path}\"",
    "rm -rf \"$(dirname \"${var.remote_kubeconfig_path}\")\""
  ]

  agent               = var.ssh.agent
  host                = var.ssh.host
  port                = var.ssh.port
  user                = var.ssh.user
  password            = var.ssh.password
  private_key         = var.ssh.private_key
  bastion_host        = var.ssh.bastion_host
  bastion_port        = var.ssh.bastion_port
  bastion_user        = var.ssh.bastion_user
  bastion_password    = var.ssh.bastion_password
  bastion_private_key = var.ssh.bastion_private_key
}

resource "ssh_resource" "k8s_kubeconfig_copy" {
  depends_on = [ssh_resource.k8s_init]

  commands = [
    "install -d -m 700 \"$(dirname \"${var.remote_kubeconfig_path}\")\"",
    "sudo cp -f \"${var.remote_admin_kubeconfig_path}\" \"${var.remote_kubeconfig_path}\"",
    "sudo chown $(id -u):$(id -g) \"${var.remote_kubeconfig_path}\""
  ]

  agent               = var.ssh.agent
  host                = var.ssh.host
  port                = var.ssh.port
  user                = var.ssh.user
  password            = var.ssh.password
  private_key         = var.ssh.private_key
  bastion_host        = var.ssh.bastion_host
  bastion_port        = var.ssh.bastion_port
  bastion_user        = var.ssh.bastion_user
  bastion_password    = var.ssh.bastion_password
  bastion_private_key = var.ssh.bastion_private_key
}

resource "ssh_resource" "get_certificate_authority" {
  depends_on = [ssh_resource.k8s_init]
  commands = [
    "cat \"${var.remote_ca_path}\""
  ]

  agent               = var.ssh.agent
  host                = var.ssh.host
  port                = var.ssh.port
  user                = var.ssh.user
  password            = var.ssh.password
  private_key         = var.ssh.private_key
  bastion_host        = var.ssh.bastion_host
  bastion_port        = var.ssh.bastion_port
  bastion_user        = var.ssh.bastion_user
  bastion_password    = var.ssh.bastion_password
  bastion_private_key = var.ssh.bastion_private_key
}

resource "shell_script" "certificate_authority" {
  depends_on = [ssh_resource.get_certificate_authority]

  lifecycle_commands {
    create = <<-EOT
      install -d -m 700 "$(dirname '${local.local_ca_path}')"
      echo '${resource.ssh_resource.get_certificate_authority.result}' \
        | install -m 600 /dev/stdin '${local.local_ca_path}'
    EOT
    read   = "echo '{}'"
    delete = <<-EOT
      rm -f '${local.local_ca_path}'
    EOT
  }
}

resource "shell_script" "client_key" {
  lifecycle_commands {
    create = <<-EOT
      install -d -m 700 "$(dirname '${local.local_key_path}')" "$(dirname '${local.local_csr_path}')"
      openssl req -new -newkey rsa:2048 \
        -keyout '${local.local_key_path}' -out '${local.local_csr_path}' \
        -subj "/CN=$USER/O=admin" -nodes
    EOT
    read   = <<-EOT
      cat <<EOF
      {
        "csr_name": "$USER-csr",
        "csr": {
          "apiVersion": "certificates.k8s.io/v1",
          "kind": "CertificateSigningRequest",
          "metadata": {
            "name": "$USER-csr"
          },
          "spec": {
            "request": "$(cat '${local.local_csr_path}' | base64 | tr -d '\n')",
            "signerName": "kubernetes.io/kube-apiserver-client",
            "usages": [
              "client auth"
            ]
          }
        }
      }
      EOF
    EOT
    delete = <<-EOT
      rm -f '${local.local_key_path}'
      rm -f '${local.local_csr_path}'
    EOT
  }
}

data "shell_script" "cluster_role_binding" {
  lifecycle_commands {
    read = <<-EOT
      cat <<EOF
      {
        "data": {
          "apiVersion": "rbac.authorization.k8s.io/v1",
          "kind": "ClusterRoleBinding",
          "metadata": {
            "name": "$USER-cluster-admin"
          },
          "roleRef": {
            "kind": "ClusterRole",
            "name": "cluster-admin",
            "apiGroup": "rbac.authorization.k8s.io"
          },
          "subjects": [
            {
              "kind": "User",
              "name": "$USER",
              "apiGroup": "rbac.authorization.k8s.io"
            }
          ]
        }
      }
      EOF
    EOT
  }
}

resource "ssh_sensitive_resource" "approve_certificate" {
  depends_on = [
    ssh_resource.k8s_init,
    ssh_resource.k8s_kubeconfig_copy,
    shell_script.client_key,
    data.shell_script.cluster_role_binding
  ]
  commands = [
    "echo '${resource.shell_script.client_key.output.csr}' | kubectl apply -f -",
    "echo '${data.shell_script.cluster_role_binding.output.data}' | kubectl apply -f -",
    "kubectl certificate approve '${resource.shell_script.client_key.output.csr_name}'",
    "sleep 5",
    "kubectl get csr '${resource.shell_script.client_key.output.csr_name}' -o jsonpath='{.status.certificate}'"
  ]

  agent               = var.ssh.agent
  host                = var.ssh.host
  port                = var.ssh.port
  user                = var.ssh.user
  password            = var.ssh.password
  private_key         = var.ssh.private_key
  bastion_host        = var.ssh.bastion_host
  bastion_port        = var.ssh.bastion_port
  bastion_user        = var.ssh.bastion_user
  bastion_password    = var.ssh.bastion_password
  bastion_private_key = var.ssh.bastion_private_key
}

resource "shell_script" "certificate" {
  depends_on = [ssh_sensitive_resource.approve_certificate]

  lifecycle_commands {
    create = <<-EOT
      install -d -m 700 "$(dirname '${local.local_crt_path}')"
      echo '${resource.ssh_sensitive_resource.approve_certificate.result}' \
        | base64 -d \
        | install -m 600 /dev/stdin '${local.local_crt_path}'
    EOT
    read   = "echo '{}'"
    delete = <<-EOT
      rm -f '${local.local_crt_path}'
    EOT
  }
}

resource "shell_script" "kubeconfig" {
  depends_on = [shell_script.certificate_authority, shell_script.certificate]

  lifecycle_commands {
    create = <<-EOT
      kubectl config \
        --kubeconfig '${local.local_kubeconfig_path}' \
        set-cluster '${var.node_name}' \
          --server='${var.api_server}' \
          --certificate-authority='${local.local_ca_path}' \
          --embed-certs=true
      kubectl config \
        --kubeconfig '${local.local_kubeconfig_path}' \
        set-credentials "$USER" \
          --client-certificate='${local.local_crt_path}' \
          --client-key='${local.local_key_path}' \
          --embed-certs=true
      kubectl config \
        --kubeconfig '${local.local_kubeconfig_path}' \
        set-context "$USER-context" \
          --cluster='${var.node_name}' \
          --user="$USER"
      kubectl config \
        --kubeconfig '${local.local_kubeconfig_path}' \
        use-context "$USER-context"
    EOT
    read   = "echo '{}'"
    delete = <<-EOT
      kubectl config \
        --kubeconfig '${local.local_kubeconfig_path}' \
        delete-context "$USER-context" \
          --cluster='${var.node_name}' \
          --user="$USER"
      kubectl config \
        --kubeconfig '${local.local_kubeconfig_path}' \
        delete-user "$USER"
      kubectl config \
        --kubeconfig '${local.local_kubeconfig_path}' \
        delete-cluster '${var.node_name}'
    EOT
  }
}

resource "shell_script" "remove_labels" {
  depends_on = [shell_script.kubeconfig]

  lifecycle_commands {
    create = <<-EOT
      kubectl --kubeconfig '${local.local_kubeconfig_path}' \
        label nodes --all node.kubernetes.io/exclude-from-external-load-balancers-
    EOT
    read   = "echo '{}'"
    delete = ""
  }
}

resource "shell_script" "patch_resolv_conf_path" {
  depends_on = [shell_script.kubeconfig]

  lifecycle_commands {
    create = <<-EOT
      kubectl --kubeconfig '${local.local_kubeconfig_path}' \
        get configmap \
        -n kube-system \
        kubelet-config \
        -o yaml \
      | sed -e "s|resolvConf: /run/systemd/resolve/resolv.conf|resolvConf: ${var.remote_resolv_conf_path}|" \
      | kubectl --kubeconfig '${local.local_kubeconfig_path}' apply -f - -n kube-system
    EOT
    read   = "echo '{}'"
    delete = ""
  }
}
