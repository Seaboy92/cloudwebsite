resource "google_compute_backend_bucket" "website" {
  name        = "${var.name_prefix}-backend-bucket"
  description = "Backend-Bucket für statische Website mit Cloud CDN"
  bucket_name = var.bucket_name
  enable_cdn  = true

  cdn_policy {
    cache_mode        = "CACHE_ALL_STATIC"
    client_ttl        = 3600
    default_ttl       = 3600
    max_ttl           = 86400
    negative_caching  = true
    serve_while_stale = 86400
  }
}
