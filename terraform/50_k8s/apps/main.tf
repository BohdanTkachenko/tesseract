module "whoami" {
  source = "./whoami"
  providers = {
    helm = helm
  }

  namespace     = "whoami"
  whoami_domain = "whoami.tesseract.sh"
}
