variable "bucket_name" {
  description = "Name des Storage Buckets"
  type        = string
}

variable "location" {
  description = "Standort des Buckets"
  type        = string
  default     = "EU"
}

variable "website_source_path" {
  description = "Relativer Pfad zum Website-Verzeichnis vom Environment aus (z.B. ../../../Website)"
  type        = string
  default     = "../../../Website"
}
