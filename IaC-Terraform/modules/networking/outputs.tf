output "load_balancer_ip" {
  value = google_compute_global_address.website.address
}

output "url_map_name" {
  value = google_compute_url_map.website.name
}
