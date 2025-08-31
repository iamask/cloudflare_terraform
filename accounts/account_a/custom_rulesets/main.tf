# Account-Level Custom WAF Rules using Cloudflare Terraform Provider v5

# Step 1: Create first custom ruleset for security rules
resource "cloudflare_ruleset" "account_custom_ruleset_1" {
  account_id  = var.ACCOUNT_ID
  name        = "Account Custom WAF Rules - Security"
  description = "Security-focused WAF ruleset for account-level protection"
  kind        = "custom"
  phase       = "http_request_firewall_custom"

  rules = [
    {
      action      = "block"
      description = "Block non-standard ports"
      enabled     = true
      expression  = "(not cf.edge.server_port in {80 443})"
    },
    {
      action      = "block"
      description = "Block specific country traffic"
      enabled     = true
      expression  = "(http.host eq \"www.zxc.co.in\" and ip.geoip.country eq \"IN\")"
    },
    {
      action = "challenge"
      action_parameters = {
        version = "managed"
      }
      description = "Challenge suspicious bots"
      enabled     = true
      expression  = "(http.user_agent contains \"bot\" and not cf.bot_management.verified_bot)"
    },
    {
      action = "log"
      action_parameters = {
        request = {
          fields = ["cf.threat_score", "cf.edge.server_port", "http.request.uri.path"]
        }
      }
      description = "Log high threat score"
      enabled     = true
      expression  = "(cf.threat_score > 30)"
    }
  ]
}

# Step 2: Create second custom ruleset for API protection
resource "cloudflare_ruleset" "account_custom_ruleset_2" {
  account_id  = var.ACCOUNT_ID
  name        = "Account Custom WAF Rules - API Protection"
  description = "API-focused WAF ruleset for account-level protection"
  kind        = "custom"
  phase       = "http_request_firewall_custom"

  rules = [
    {
      action      = "block"
      description = "Block requests without API key header"
      enabled     = true
      expression  = "(http.request.uri.path contains \"/api/\" and not http.request.headers[\"x-api-key\"][0])"
    },
    {
      action      = "block"
      description = "Block SQL injection attempts"
      enabled     = true
      expression  = "(http.request.uri.query contains \"UNION\" or http.request.uri.query contains \"SELECT\" or http.request.body.raw contains \"DROP TABLE\")"
    },
    {
      action = "challenge"
      action_parameters = {
        version = "managed"
      }
      description = "Challenge unusual user agents on API endpoints"
      enabled     = true
      expression  = "(http.request.uri.path contains \"/api/\" and not http.user_agent contains any {\"Mozilla\" \"Chrome\" \"Safari\" \"curl\" \"Postman\"})"
    },
    {
      action      = "block"
      description = "Block oversized requests to API"
      enabled     = true
      expression  = "(http.request.uri.path contains \"/api/\" and http.request.body.size > 10485760)"
    }
  ]
}

# Step 3: Deploy both rulesets via account-level entrypoint
resource "cloudflare_ruleset" "account_firewall_custom_entrypoint" {
  account_id  = var.ACCOUNT_ID
  name        = "Account WAF Custom Rules Deployment"
  description = "Execute account-level custom rules in this zone"
  kind        = "root"
  phase       = "http_request_firewall_custom"

  depends_on = [
    cloudflare_ruleset.account_custom_ruleset_1,
    cloudflare_ruleset.account_custom_ruleset_2
  ]

  rules = [
    {
      action     = "execute"
      expression = "(http.host eq \"www.zxc.co.in\")"
      action_parameters = {
        id = cloudflare_ruleset.account_custom_ruleset_1.id
      }
      description = "Execute security custom rules"
      enabled     = true
    },
    {
      action     = "execute"
      expression = "(http.host eq \"api.zxc.co.in\" or http.request.uri.path contains \"/test/\")"
      action_parameters = {
        id = cloudflare_ruleset.account_custom_ruleset_2.id
      }
      description = "Execute API protection custom rules"
      enabled     = true
    },
    {
      action     = "execute"
      expression = "(http.host eq \"demo2.zxc.co.in\")"
      action_parameters = {
        id = cloudflare_ruleset.account_custom_ruleset_1.id
      }
      description = "reuse account_custom_ruleset_1 for demo2 "
      enabled     = true
    }
  ]
}

output "account_deployment_status" {
  value       = "✓ Custom rules deployed to account ${var.ACCOUNT_ID}"
  description = "Account deployment status"
}
