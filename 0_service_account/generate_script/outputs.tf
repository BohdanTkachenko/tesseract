output "create_service_account" {
  value = replace(
    replace(
      file("./scripts/remote_create_service_account.sh"),
      "__REPLACEME_SERVICE_ACCOUNT_PUB_KEY__",
      trimspace(var.public_key),
    ),
    "__REPLACEME_SERVICE_ACCOUNT_NAME__",
    var.username,
  )
}

output "username" {
  value = var.username
}
