locals {
  # Die für dieses Projekt benötigten APIs werden im Bootstrap aktiviert,
  # damit das eigentliche Environment später ohne manuelle Vorarbeit läuft.
  required_services = toset([
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
  ])
}

# Anlegen des Projektes
resource "google_project" "bootstrap_target" {
  project_id      = var.project_id
  name            = var.project_name
  billing_account = var.billing_account

  # folder_id hat Vorrang vor org_id, falls beides gesetzt wurde.
  # So bleibt das Verhalten auch bei späteren Anpassungen eindeutig.
  org_id    = var.folder_id == null ? var.org_id : null
  folder_id = var.folder_id
}

resource "google_project_service" "required" {
  for_each = local.required_services

  project = google_project.bootstrap_target.project_id
  service = each.value

  disable_on_destroy = false
}

# Erstellung des Storage Buckets für den Terraform State
resource "google_storage_bucket" "terraform_state" {
  name     = var.state_bucket_name
  location = var.state_bucket_location
  project  = google_project.bootstrap_target.project_id

  # Versionierung erleichtert das Recovern eines versehentlich überschriebenen States.
  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true

  depends_on = [google_project_service.required]
}

# Anlegen eines Service Accounts für Terraform mit den notwendigen Berechtigungen
resource "google_service_account" "terraform" {
  project      = google_project.bootstrap_target.project_id
  account_id   = var.terraform_service_account_id
  display_name = var.terraform_service_account_display_name

  depends_on = [google_project_service.required]
}

# Berechtigungen für den Terraform Service Account zur Erstellung von Dienstkonto-Tokens
resource "google_service_account_iam_member" "terraform_impersonator" {
  service_account_id = google_service_account.terraform.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = var.bootstrap_user_member
}

# Berechtigung für den menschlichen Benutzer, um den Terraform Service Account zu impersonalisieren
resource "google_project_iam_member" "bootstrap_user_project_roles" {
  for_each = var.bootstrap_user_project_roles

  project = google_project.bootstrap_target.project_id
  role    = each.value
  member  = var.bootstrap_user_member
}

# Berechtigungen für den Terraform Service Account, um die benötigten APIs zu aktivieren und Ressourcen zu verwalten
resource "google_project_iam_member" "terraform_service_account_roles" {
  for_each = var.terraform_service_account_roles

  project = google_project.bootstrap_target.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.terraform.email}"
}
