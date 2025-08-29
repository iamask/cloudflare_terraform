# Account-level WAF Ruleset Configuration

# Step 1: Create custom ruleset at account level
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

# Step 2: Import and manage existing root ruleset
# IMPORTANT: First run this import command to take over management of the existing root ruleset:
# terraform import module.account_waf.cloudflare_ruleset.account_waf_entrypoint account/174f936387e2cf4c433752dc46ba6bb1/1c4cd4c02f38487291480b7824fca8e9
#
# After import, this will update the existing root ruleset to execute our custom ruleset
resource "cloudflare_ruleset" "account_waf_entrypoint" {
  account_id  = var.ACCOUNT_ID
  name        = "root"
  description = ""
  kind        = "root"
  phase       = "http_request_firewall_custom"

  # Add our custom ruleset execution rule
  rules = [{
    ref         = "deploy_custom_ruleset_zxc"
    description = "Execute custom ruleset for zxc.co.in"
    expression  = "(cf.zone.name contains \"zxc.co.in\") and (cf.zone.plan eq \"ENT\")"
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
  description = "ID of the root ruleset that deploys the custom ruleset"
}
