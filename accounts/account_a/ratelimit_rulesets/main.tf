# Account-Level Rate Limiting Rules using Cloudflare Terraform Provider v5

# Step 1: Create rate limiting ruleset
resource "cloudflare_ruleset" "account_ratelimit_ruleset" {
  account_id  = var.ACCOUNT_ID
  name        = "Account Rate Limiting Rules"
  description = "Rate limiting ruleset for account-level protection"
  kind        = "custom"
  phase       = "http_ratelimit"

  rules = [
    {
      action = "block"
      action_parameters = {
        response = {
          status_code = 429
          content = "Too many requests"
          content_type = "text/plain"
        }
      }
      ratelimit = {
        characteristics = ["cf.colo.id", "ip.src"]
        period = 60
        requests_per_period = 50
        mitigation_timeout = 600
      }
      description = "Rate limit per IP - 50 requests per minute"
      enabled     = true
      expression  = "(http.request.uri.path contains \"/api/\")"
    },
    {
      action = "block"
      action_parameters = {
        response = {
          status_code = 429
          content = "Rate limit exceeded"
          content_type = "text/plain"
        }
      }
      ratelimit = {
        characteristics = ["cf.colo.id", "ip.src", "http.request.uri.path"]
        period = 10
        requests_per_period = 10
        mitigation_timeout = 60
      }
      description = "Strict rate limit for login endpoint"
      enabled     = true
      expression  = "(http.request.uri.path eq \"/login\" and http.request.method eq \"POST\")"
    },
    {
      action = "challenge"
      action_parameters = {
        version = "managed"
      }
      ratelimit = {
        characteristics = ["cf.colo.id", "http.request.headers[\"x-api-key\"][0]"]
        period = 3600
        requests_per_period = 1000
        mitigation_timeout = 3600
      }
      description = "Challenge API key abuse - 1000 requests per hour"
      enabled     = true
      expression  = "(http.request.headers[\"x-api-key\"][0] ne \"\" and http.request.uri.path contains \"/api/v2/\")"
    },
    {
      action = "log"
      ratelimit = {
        characteristics = ["cf.colo.id", "ip.src"]
        period = 60
        requests_per_period = 100
        mitigation_timeout = 0
      }
      description = "Log high request rate patterns"
      enabled     = true
      expression  = "(http.host eq \"www.zxc.co.in\")"
    }
  ]
}

# Step 2: Deploy rate limiting rules at account level
resource "cloudflare_ruleset" "account_ratelimit_entrypoint" {
  account_id  = var.ACCOUNT_ID
  name        = "Account Rate Limiting Deployment"
  description = "Execute account-level rate limiting rules"
  kind        = "root"
  phase       = "http_ratelimit"

  depends_on = [cloudflare_ruleset.account_ratelimit_ruleset]

  rules = [
    {
      action     = "execute"
      expression = "(http.host in {\"www.zxc.co.in\" \"api.zxc.co.in\"})"
      action_parameters = {
        id = cloudflare_ruleset.account_ratelimit_ruleset.id
      }
      description = "Execute rate limiting rules for specified domains"
      enabled     = true
    }
  ]
}

# Outputs
output "ratelimit_ruleset_id" {
  value       = cloudflare_ruleset.account_ratelimit_ruleset.id
  description = "Rate limiting ruleset ID"
}

output "ratelimit_deployment_status" {
  value       = "✓ Rate limiting rules deployed to account ${var.ACCOUNT_ID}"
  description = "Rate limiting deployment status"
}
