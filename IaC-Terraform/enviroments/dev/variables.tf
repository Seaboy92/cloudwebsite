variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west3" # Frankfurt
}

variable "bucket_location" {
  description = "Bucket-Standort für die Origin-Daten"
  type        = string
  default     = "EU"
}

variable "bucket_name" {
  type = string
}

variable "name_prefix" {
  description = "Präfix für Load-Balancer- und CDN-Ressourcen"
  type        = string
  default     = "dev-static-site"
}

variable "website_source_path" {
  description = "Relativer Pfad zum Website-Verzeichnis vom dev-Environment aus"
  type        = string
  default     = "../../../Website"
}

variable "terraform_service_account_email" {
  description = "E-Mail des Terraform-Service-Accounts, der fuer die Erstellung der Projektressourcen impersoniert wird"
  type        = string
}