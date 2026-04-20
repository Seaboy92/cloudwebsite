terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Für das Bootstrap wird bewusst kein Remote-Backend verwendet.
# Der State liegt lokal, bis der GCS-State-Bucket erstellt wurde.
provider "google" {
  region = var.region
}
