module "homeassistant" {
  source = "./homeassistant"
  providers = {
    helm = helm
  }

  namespace             = "homeassistant"
  gateway_name          = "cilium"
  gateway_namespace     = "kube-cilium"
  homeassistant_domain  = "home.cyber.place"
  homeassistant_address = "10.0.0.11"
}

module "media" {
  source = "./media"
  providers = {
    helm = helm
  }

  namespace                      = "media"
  gateway_name                   = "cilium"
  gateway_namespace              = "kube-cilium"
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

module "stash" {
  source = "./stash"
  providers = {
    helm = helm
  }

  namespace                          = "stash"
  gateway_name                       = "cilium"
  gateway_namespace                  = "kube-cilium"
  stash_domain                       = "stash.tesseract.sh"
  stash_ip                           = "10.42.0.69"
  stash_config_storage_class_name    = "fast-local-path"
  stash_config_quota                 = "100Mi"
  stash_metadata_storage_class_name  = "fast-local-path"
  stash_metadata_quota               = "1Gi"
  stash_cache_storage_class_name     = "fast-local-path"
  stash_cache_quota                  = "1Gi"
  stash_blobs_storage_class_name     = "fast-local-path"
  stash_blobs_quota                  = "10Gi"
  stash_generated_storage_class_name = "fast-local-path"
  stash_generated_quota              = "200Gi"
  videos_storage_class_name          = "slow-local-path"
  videos_quota                       = "5Ti"
  images_storage_class_name          = "slow-local-path"
  images_quota                       = "10Gi"
  vaultwarden_storage_class_name     = "fast-local-path"
  vaultwarden_quota                  = "100Mi"
}

module "whoami" {
  source = "./whoami"
  providers = {
    helm = helm
  }

  namespace         = "whoami"
  gateway_name      = "cilium"
  gateway_namespace = "kube-cilium"
  whoami_domain     = "whoami.tesseract.sh"
}
