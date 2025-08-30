# Step 1: Create/update the custom ruleset with your rules
resource "cloudflare_ruleset" "account_waf_custom" {
  account_id  = var.ACCOUNT_ID
  name        = "Custom ruleset blocking traffic in non-standard HTTP(S) ports"
  description = "Custom WAF rules for account"
  kind        = "custom"
  phase       = "http_request_firewall_custom"

  rules = [{
    description = "Block ports other than 80 and 443"
    expression  = "(not cf.edge.server_port in {80 443})"
    action      = "block"
    enabled     = true
  }]
}

# Step 2: Use PUT to update the existing root ruleset
# NOTE: This will replace the existing root ruleset with ID: 1c4cd4c02f38487291480b7824fca8e9
# Any existing rules in that ruleset will be replaced
resource "cloudflare_ruleset" "account_waf_entrypoint" {
  account_id  = var.ACCOUNT_ID
  name        = "root"
  description = "Account-level WAF Custom Phase"
  kind        = "root"
  phase       = "http_request_firewall_custom"
  
  # Deploy our custom ruleset for specific zones
  rules = [{
    description = "Deploy custom ruleset for zxc.co.in zones"
    expression  = "(cf.zone.name contains \"zxc.co.in\")"
    action      = "execute"
    action_parameters = {
      id = cloudflare_ruleset.account_waf_custom.id
    }
    enabled = true
  }]

  depends_on = [cloudflare_ruleset.account_waf_custom]
  
  lifecycle {
    # This will replace the existing root ruleset
    create_before_destroy = false
  }
}

output "custom_ruleset_id" {
  value       = cloudflare_ruleset.account_waf_custom.id
  description = "ID of the custom WAF ruleset"
}

output "root_ruleset_id" {
  value       = cloudflare_ruleset.account_waf_entrypoint.id
  description = "ID of the root ruleset"
}
