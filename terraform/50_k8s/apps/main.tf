module "homeassistant" {
  source = "./homeassistant"
  providers = {
    helm = helm
  }

  namespace             = "homeassistant"
  homeassistant_domain  = "home.cyber.place"
  homeassistant_address = "10.0.0.11"
}

module "media" {
  source = "./media"
  providers = {
    helm = helm
  }

  namespace                      = "media"
  timezone                       = "America/New_York"
  plex_domain                    = "plex.tesseract.sh"
  plex_ip                        = "10.42.0.32"
  plex_config_storage_class_name = "fast-local-path"
  plex_config_quota              = "20Gi"
  movies_storage_class_name      = "slow-local-path"
  movies_quota                   = "20Ti"
  tvshows_storage_class_name     = "slow-local-path"
  tvshows_quota                  = "20Ti"
}

module "whoami" {
  source = "./whoami"
  providers = {
    helm = helm
  }

  namespace     = "whoami"
  whoami_domain = "whoami.tesseract.sh"
}
