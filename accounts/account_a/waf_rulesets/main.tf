# Account-Level Custom WAF Rules using Cloudflare Terraform Provider v5

# Step 1: Create custom ruleset
resource "cloudflare_ruleset" "account_custom_rules" {
  account_id  = var.ACCOUNT_ID
  name        = "Account Custom WAF Rules"
  description = "Custom WAF ruleset for account-level rules"
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
      description = "Block US traffic to www.zxc.co.in"
      enabled     = true
      expression  = "(http.host eq \"www.zxc.co.in\" and ip.geoip.country eq \"US\")"
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

# Step 2: Deploy via zone-level ruleset (alternative approach)
# Since account already has a root ruleset, deploy at zone level instead
resource "cloudflare_ruleset" "zone_execute_custom_rules" {
  count       = var.ZONE_ID != "" ? 1 : 0
  zone_id     = var.ZONE_ID
  name        = "Zone WAF Custom Rules Deployment"
  description = "Execute account-level custom rules in this zone"
  kind        = "zone"
  phase       = "http_request_firewall_custom"

  rules = [
    {
      action = "execute"
      action_parameters = {
        id = cloudflare_ruleset.account_custom_rules.id
      }
      description = "Execute account custom rules"
      enabled     = true
      expression  = "true"
    }
  ]
}

output "custom_ruleset_id" {
  value       = cloudflare_ruleset.account_custom_rules.id
  description = "ID of the custom WAF ruleset"
}

output "zone_deployment_status" {
  value = var.ZONE_ID != "" ? "✓ Custom rules deployed to zone ${var.ZONE_ID}" : "⚠ Add ZONE_ID variable to deploy to a zone"
  description = "Zone deployment status"
}
