# Variables for Account-level WAF Ruleset Configuration

variable "ACCOUNT_ID" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "API_TOKEN" {
  description = "Cloudflare API Token with appropriate permissions"
  type        = string
  sensitive   = true
}

variable "ZONE_ID" {
  description = "Cloudflare Zone ID for zone-level deployment (optional)"
  type        = string
  default     = ""
}
