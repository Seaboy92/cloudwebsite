output "backend_bucket_id" {
  value = google_compute_backend_bucket.website.id
}

output "backend_bucket_name" {
  value = google_compute_backend_bucket.website.name
}
