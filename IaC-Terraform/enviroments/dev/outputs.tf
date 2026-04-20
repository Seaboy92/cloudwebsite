output "bucket_name" {
  value = module.storage.bucket_name
}

output "load_balancer_ip" {
  value = module.networking.load_balancer_ip
}

output "website_url" {
  value = "http://${module.networking.load_balancer_ip}"
}
