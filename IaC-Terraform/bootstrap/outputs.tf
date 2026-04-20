output "project_id" {
  description = "Projekt-ID des neu erzeugten GCP-Projekts."
  value       = google_project.bootstrap_target.project_id
}

output "project_number" {
  description = "Projektnummer des neu erzeugten GCP-Projekts."
  value       = google_project.bootstrap_target.number
}

output "state_bucket_name" {
  description = "Name des erzeugten GCS-Buckets fuer das Terraform-Backend."
  value       = google_storage_bucket.terraform_state.name
}

output "terraform_service_account_email" {
  description = "E-Mail-Adresse des Terraform-Service-Accounts."
  value       = google_service_account.terraform.email
}

output "backend_prefix" {
  description = "Vorgeschlagener Prefix fuer das Environment-Statefile."
  value       = "static-website"
}
