# Variables for Account-level Managed WAF Ruleset Configuration

variable "ACCOUNT_ID" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "API_TOKEN" {
  description = "Cloudflare API Token with appropriate permissions"
  type        = string
  sensitive   = true
}
