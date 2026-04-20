# Reservierung einer globalen IP-Adresse für die Website
resource "google_compute_global_address" "website" {
  name = "${var.name_prefix}-ip"
}

# Weiterleitung der Anfragen an den Backend-Bucket
resource "google_compute_url_map" "website" {
  name            = "${var.name_prefix}-url-map"
  default_service = var.backend_bucket_id
}

# HTTP-Proxy für den Load Balancer
resource "google_compute_target_http_proxy" "website" {
  name    = "${var.name_prefix}-http-proxy"
  url_map = google_compute_url_map.website.id
}

# Verknüpung der öffentlichen IP-Adresse mit dem HTTP-Proxy mit Port 80 über eine globale Weiterleitungsregel
# Weitreitung der Anfragen an den HTTP-Proxy, damit diese an den Backend-Bucket weitergeleitet werden
resource "google_compute_global_forwarding_rule" "website" {
  name                  = "${var.name_prefix}-http-forwarding-rule"
  ip_address            = google_compute_global_address.website.id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.website.id
}
