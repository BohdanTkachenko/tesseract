output "domains" {
  value = {
    for domain in var.domains :
    replace(domain, ".", "_") => domain
  }
}
