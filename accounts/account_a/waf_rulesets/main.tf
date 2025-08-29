# Account-level WAF Ruleset Configuration
# Simple geo-blocking rule for test.zxc.co.in

resource "cloudflare_ruleset" "account_waf_custom" {
  account_id  = var.ACCOUNT_ID
  name        = "Account Level Custom WAF Rules"
  description = "Custom WAF rules - Geo blocking for test.zxc.co.in"
  kind        = "custom"
  phase       = "http_request_firewall_custom"

  rules = [
    # Geo-block US traffic for test.zxc.co.in
    {
      action = "block"
      action_parameters = {
        response = {
          status_code = 403
          content     = "Access denied - Geographic restriction"
          content_type = "text/plain"
        }
      }
      expression  = "(http.host eq \"test.zxc.co.in\" and ip.geoip.country eq \"US\")"
      description = "Block US traffic to test.zxc.co.in"
      enabled     = true
    }
  ]
}

# Deploy the custom ruleset to all zones in the account
resource "cloudflare_ruleset" "account_waf_deployment" {
  account_id  = var.ACCOUNT_ID
  name        = "Account WAF Deployment"
  description = "Deploy custom WAF rules to all zones"
  kind        = "root"
  phase       = "http_request_firewall_custom"

  rules = [
    {
      action = "execute"
      action_parameters = {
        id = cloudflare_ruleset.account_waf_custom.id
      }
      expression  = "true"
      description = "Execute custom WAF ruleset for all zones"
      enabled     = true
    }
  ]
}

# Output the ruleset IDs for reference
output "custom_waf_ruleset_id" {
  value       = cloudflare_ruleset.account_waf_custom.id
  description = "ID of the custom WAF ruleset"
}

output "deployment_ruleset_id" {
  value       = cloudflare_ruleset.account_waf_deployment.id
  description = "ID of the deployment ruleset"
}
