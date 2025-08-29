# Account-level WAF Ruleset Configuration
# Creates custom ruleset at account level
# 
# NOTE: To deploy this ruleset, you need to update the existing root ruleset (ID: 1c4cd4c02f38487291480b7824fca8e9)
# Add an execute rule pointing to this custom ruleset ID after it's created

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

# Output the ruleset ID for reference
output "custom_ruleset_id" {
  value       = cloudflare_ruleset.account_waf_custom.id
  description = "ID of the custom WAF ruleset - Deploy by updating existing root ruleset"
}
