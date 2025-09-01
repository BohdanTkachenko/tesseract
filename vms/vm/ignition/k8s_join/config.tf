resource "random_string" "join_token_id" {
  length  = 6
  special = false
  upper   = false
  keepers = {
    hostname = var.hostname
  }
}

resource "random_string" "join_token_secret" {
  length  = 16
  special = false
  upper   = false
}

resource "kubernetes_secret" "bootstrap_token" {
  depends_on = [ random_string.join_token_id, random_string.join_token_secret ]

  metadata {
    name      = "bootstrap-token-${random_string.join_token_id.result}"
    namespace = "kube-system"
  }

  type = "bootstrap.kubernetes.io/token"
  data = {
    "token-id" = random_string.join_token_id.result
    "token-secret" = random_string.join_token_secret.result
    "expiration" = timeadd(timestamp(), "1h")
    "auth-extra-groups" = "system:bootstrappers:kubeadm:default-node-token"
    "usage-bootstrap-authentication" = "true"
    "usage-bootstrap-signing" = "true"
  }
}

data "shell_script" "k8s_info" {
  lifecycle_commands {
    read = <<-EOT
      server=$( \
        kubectl config view \
          --minify \
          --output jsonpath="{.clusters[*].cluster.server}" \
        | sed 's|^https\?://||' \
      )
      ca_hash=$( \
        openssl x509 -pubkey -in ${pathexpand(var.k8s_ca_path)} \
        | openssl rsa -pubin -outform der 2>/dev/null \
        | openssl dgst -sha256 -hex | sed 's/^.* //' \
      )
      cat << EOF
      {
          "server": "$server",
          "ca_hash": "$ca_hash"
      }
      EOF
    EOT
  }
}

data "ignition_file" "join_config" {
  depends_on = [ kubernetes_secret.bootstrap_token ]

  path = "/etc/kubernetes/join-config.yaml"
  contents {
    source = "data:text/plain;charset=utf-8;base64,${base64encode(
      templatefile("${path.module}/contents/files/etc/kubernetes/join-config.yaml", {
        k8s_server  = trimspace(data.shell_script.k8s_info.output.server)
        k8s_ca_hash = trimspace(data.shell_script.k8s_info.output.ca_hash)
        k8s_token   = "${random_string.join_token_id.result}.${random_string.join_token_secret.result}"
      })
    )}"
  }
}
