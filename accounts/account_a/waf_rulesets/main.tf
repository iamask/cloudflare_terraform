resource "cloudflare_ruleset" "account_waf_custom" {
  account_id  = var.ACCOUNT_ID
  name        = "Custom ruleset blocking traffic in non-standard HTTP(S) ports"
  description = ""
  kind        = "custom"
  phase       = "http_request_firewall_custom"

  rules = [{
    ref         = "block_non_default_ports."
    description = "Block ports other than 80 and 443"
    expression  = "(not cf.edge.server_port in {80 443})"
    action      = "block"
  }]
}

resource "cloudflare_ruleset" "account_waf_entrypoint" {
  account_id  = var.ACCOUNT_ID
  name        = "root"
  description = ""
  kind        = "root"
  phase       = "http_request_firewall_custom"
  depends_on  = [cloudflare_ruleset.account_waf_custom]

  # Add our custom ruleset execution rule
  rules = [{
    ref         = "deploy_custom_ruleset_zxc"
    description = "Deploy custom ruleset for example.com"
    expression  = "(cf.zone.name eq \"example.com\") and (cf.zone.plan eq \"ENT\")"
    action      = "execute"
    action_parameters = {
      id = cloudflare_ruleset.account_waf_custom.id
    }
  }]

  lifecycle {
    # Prevent accidental recreation - we're managing an existing resource
    prevent_destroy = true
  }
}

output "custom_ruleset_id" {
  value       = cloudflare_ruleset.account_waf_custom.id
  description = "ID of the custom WAF ruleset"
}

output "entrypoint_ruleset_id" {
  value       = cloudflare_ruleset.account_waf_entrypoint.id
  description = "ID of the root ruleset that deploys the custom ruleset"
}
