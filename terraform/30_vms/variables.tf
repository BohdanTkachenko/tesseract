variable "ssh" {
  description = "Main node SSH connection details."
  sensitive   = true
  type = object({
    host        = string
    port        = number
    user        = string
    private_key = string
  })
  default = {
    host        = "tesseract.lan"
    port        = 22
    user        = "terraform"
    private_key = "~/.ssh/terraform"
  }
}

variable "tmp_dir" {
  type    = string
  default = "/tmp"
}


variable "core_password" {
  type      = string
  sensitive = true
}
