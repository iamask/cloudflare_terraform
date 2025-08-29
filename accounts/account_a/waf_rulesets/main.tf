# Account-level WAF Ruleset Configuration
# Simple geo-blocking rule for test.zxc.co.in

# Step 1: Create the Custom Ruleset
resource "cloudflare_ruleset" "account_waf_custom" {
  account_id  = var.ACCOUNT_ID
  name        = "Custom WAF Rules for test.zxc.co.in"
  description = "Account-level custom firewall ruleset - Geo blocking"
  kind        = "custom"
  phase       = "http_request_firewall_custom"

  rules = [{
    ref         = "block_us_traffic"
    description = "Block US traffic to test.zxc.co.in"
    expression  = "(http.host eq \"test.zxc.co.in\" and ip.geoip.country eq \"US\")"
    action      = "block"
    action_parameters = {
      response = {
        status_code  = 403
        content      = "Access denied - Geographic restriction"
        content_type = "text/plain"
      }
    }
  }]
}

# Step 2: Deploy the Custom Ruleset via Entry Point
resource "cloudflare_ruleset" "account_waf_entrypoint" {
  account_id  = var.ACCOUNT_ID
  name        = "Account-level entry point ruleset"
  description = "Deploy custom ruleset for zxc.co.in zones"
  kind        = "root"
  phase       = "http_request_firewall_custom"
  depends_on  = [cloudflare_ruleset.account_waf_custom]

  rules = [{
    ref         = "deploy_custom_ruleset_zxc"
    description = "Deploy custom ruleset for zxc.co.in domains"
    expression  = "(cf.zone.name contains \"zxc.co.in\")"
    action      = "execute"
    action_parameters = {
      id = cloudflare_ruleset.account_waf_custom.id
    }
  }]
}

# Output the ruleset IDs for reference
output "custom_ruleset_id" {
  value       = cloudflare_ruleset.account_waf_custom.id
  description = "ID of the custom WAF ruleset"
}

output "entrypoint_ruleset_id" {
  value       = cloudflare_ruleset.account_waf_entrypoint.id
  description = "ID of the entry point ruleset"
}
