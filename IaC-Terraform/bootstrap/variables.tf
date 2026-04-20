variable "project_id" {
  description = "Eindeutige ID des neu anzulegenden GCP-Projekts."
  type        = string
}

variable "project_name" {
  description = "Anzeigename des neu anzulegenden GCP-Projekts."
  type        = string
}

variable "billing_account" {
  description = "Billing-Account-ID im Format 000000-000000-000000."
  type        = string
}

variable "org_id" {
  description = "Optionale Organization-ID. Leer lassen, wenn das Projekt nicht unter einer Organization angelegt wird."
  type        = string
  default     = null
}

variable "folder_id" {
  description = "Optionale Folder-ID. Wenn gesetzt, wird das Projekt in diesem Folder angelegt."
  type        = string
  default     = null

  validation {
    condition     = var.org_id == null || var.folder_id == null
    error_message = "Es darf nur org_id oder folder_id gesetzt sein, nicht beides gleichzeitig."
  }
}

variable "region" {
  description = "Standardregion für provider-seitige Operationen."
  type        = string
  default     = "europe-west3"
}

variable "state_bucket_name" {
  description = "Name des Buckets für den Terraform-Remote-State."
  type        = string
}

variable "state_bucket_location" {
  description = "Standort des Terraform-State-Buckets."
  type        = string
  default     = "EU"
}

variable "terraform_service_account_id" {
  description = "Account-ID des Service Accounts für spaetere Terraform-Laeufe."
  type        = string
  default     = "terraform-deployer"
}

variable "terraform_service_account_display_name" {
  description = "Anzeigename des Terraform-Service-Accounts."
  type        = string
  default     = "Terraform Deployer"
}

variable "terraform_service_account_roles" {
  description = "Projektrollen für den Terraform-Service-Account."
  type        = set(string)
  default = [
    "roles/compute.admin",
    "roles/storage.admin",
    "roles/iam.serviceAccountUser",
    "roles/serviceusage.serviceUsageAdmin",
  ]
}

variable "bootstrap_user_member" {
  description = "IAM-Mitglied des menschlichen Benutzers, z. B. user:name@example.com"
  type        = string
}

variable "bootstrap_user_project_roles" {
  description = "Projektrollen für den menschlichen Benutzer, damit ADC und Erstzugriff funktionieren"
  type        = set(string)
  default = [
    "roles/serviceusage.serviceUsageConsumer",
  ]
}