data "shell_script" "k8s_ca_hash" {
  lifecycle_commands {
    read = <<-EOT
      server=$( \
        kubectl config view \
          --minify \
          --output jsonpath="{.clusters[*].cluster.server}" \
        | sed 's|^https\?://||' \
      )
      ca_hash=$( \
        openssl x509 -pubkey -in ${var.k8s.ca_path} \
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
