# Account-Level Managed WAF Rules using Cloudflare Terraform Provider v5

resource "cloudflare_ruleset" "account_managed_waf_entrypoint" {
  account_id  = var.ACCOUNT_ID
  name        = "Account Managed WAF Deployment"
  description = "Deploy Cloudflare Managed WAF rulesets at account level"
  kind        = "root"
  phase       = "http_request_firewall_managed"

  rules = [
    {
      action     = "execute"
      expression = "(http.host in {\"www.zxc.co.in\" \"api.zxc.co.in\" \"demo2.zxc.co.in\"})"
      action_parameters = {
        id = "efb7b8c949ac4650a09736fc376e9aee"  # Cloudflare Managed Ruleset
        version = "latest"
        overrides = {
          enabled = true
          rules = [
            {
              id = "5de7edfa648c4d6891dc3e7f84534ffa"  # Anomaly Detection
              action = "log"
              enabled = true
            }
          ]
        }
      }
      description = "Execute Cloudflare Managed Ruleset"
      enabled     = true
    },
    {
      action     = "execute"
      expression = "(http.host in {\"www.zxc.co.in\" \"api.zxc.co.in\"})"
      action_parameters = {
        id = "4814384a9e5d4991b9815dcfc25d2f1f"  # OWASP Core Ruleset
        version = "latest"
        overrides = {
          enabled = true
          action = "block"
          categories = [
            {
              category = "paranoia-level-1"
              enabled = true
            },
            {
              category = "paranoia-level-2"
              enabled = false
            }
          ]
        }
      }
      description = "Execute OWASP Core Ruleset with paranoia level 1"
      enabled     = true
    }
  ]
}

output "managed_waf_deployment_status" {
  value       = "✓ Managed WAF rules deployed to account ${var.ACCOUNT_ID}"
  description = "Managed WAF deployment status"
}
