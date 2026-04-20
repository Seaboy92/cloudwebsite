variable "name_prefix" {
  description = "Präfix für die CDN-Ressourcen"
  type        = string
}

variable "bucket_name" {
  description = "Name des Cloud-Storage-Buckets, der als Origin dient"
  type        = string
}
