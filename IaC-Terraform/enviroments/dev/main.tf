# Einbindung des Storage-Moduls für die Speicherung der Webseite
module "storage" {
  source = "../../modules/storage"

  bucket_name         = var.bucket_name
  location            = var.bucket_location
  website_source_path = var.website_source_path
}

# Einbindung des CDN-Moduls für das Geo-Caching der Webseite
module "cdn" {
  source = "../../modules/cdn"

  name_prefix = var.name_prefix
  bucket_name = module.storage.bucket_name
}

# Einbindung des Netzwerk-Moduls für die Anbindung des CDN an das Internet mittels Load-Balancing
module "networking" {
  source = "../../modules/networking"

  name_prefix       = var.name_prefix
  backend_bucket_id = module.cdn.backend_bucket_id
}
