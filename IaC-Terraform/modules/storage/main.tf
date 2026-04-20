resource "google_storage_bucket" "website" {
  name          = var.bucket_name
  location      = var.location
  force_destroy = true

  # Website-Konfiguration für statische Inhalte
  website {
    main_page_suffix = "index.html"
  }

  # Sicherheitsfeature: Versionierung aktivieren
  versioning {
    enabled = true
  }

  # DSGVO/BSI: Zugriff kontrollieren (kein public by default!)
  uniform_bucket_level_access = true
}

# IAM-Policy für öffentlichen Zugriff auf die Website
resource "google_storage_bucket_iam_member" "public_read" {
  bucket = google_storage_bucket.website.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# Automatisches Hochladen der Website-Dateien
resource "google_storage_bucket_object" "website_files" {
  for_each = fileset(var.website_source_path, "**/*")

  name   = each.value
  source = "${var.website_source_path}/${each.value}"
  bucket = google_storage_bucket.website.name

  # Content-Type basierend auf Dateiendung setzen
  content_type = lookup({
    "html" = "text/html"
    "css"  = "text/css"
    "js"   = "application/javascript"
    "png"  = "image/png"
    "jpg"  = "image/jpeg"
    "jpeg" = "image/jpeg"
    "gif"  = "image/gif"
    "svg"  = "image/svg+xml"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "text/plain")
}