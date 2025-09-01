remote_state {
  backend = "gcs"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "tesseract-terraform"
    prefix  = path_relative_to_include()
    project = "tesseract-sh"
  }
}
