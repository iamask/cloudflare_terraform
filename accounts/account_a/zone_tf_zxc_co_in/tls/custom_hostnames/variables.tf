variable "API_TOKEN" {
  description = "Cloudflare API token"
  type        = string
  sensitive   = true
}

variable "ZONE_ID" {
  description = "Cloudflare Zone ID"
  type        = string
}
