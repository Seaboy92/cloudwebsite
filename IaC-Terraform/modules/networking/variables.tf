variable "name_prefix" {
  description = "Präfix für die globalen HTTP-Load-Balancer-Ressourcen"
  type        = string
}

variable "backend_bucket_id" {
  description = "ID des Backend-Buckets mit aktiviertem Cloud CDN"
  type        = string
}
