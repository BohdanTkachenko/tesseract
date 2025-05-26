data "shell_script" "k8s_info" {
  depends_on = [shell_script.certificate_authority, shell_script.kubeconfig]
  lifecycle_commands {
    read = <<-EOT
      server=$( \
        kubectl config view \
          --minify \
          --output jsonpath="{.clusters[*].cluster.server}" \
        | sed 's|^https\?://||' \
      )
      ca_hash=$( \
        openssl x509 -pubkey -in ${pathexpand(var.local_ca_path)} \
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
