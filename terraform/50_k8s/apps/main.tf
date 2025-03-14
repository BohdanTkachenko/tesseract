module "homeassistant" {
  source = "./homeassistant"
  providers = {
    helm = helm
  }

  namespace             = "homeassistant"
  homeassistant_domain  = "home.cyber.place"
  homeassistant_address = "10.0.0.11"
}

module "whoami" {
  source = "./whoami"
  providers = {
    helm = helm
  }

  namespace     = "whoami"
  whoami_domain = "whoami.tesseract.sh"
}
