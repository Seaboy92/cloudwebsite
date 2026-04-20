output "bucket_name" {
  value = google_storage_bucket.website.name
}

output "bucket_self_link" {
  value = google_storage_bucket.website.self_link
}
