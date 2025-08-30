################################################################################
# Account-Level Custom WAF Rules Configuration
# This module creates and deploys custom WAF rules at the account level
# using Cloudflare Terraform Provider v5
################################################################################

# Step 1: Create the custom ruleset with your WAF rules
resource "cloudflare_ruleset" "account_custom_rules" {
  account_id  = var.ACCOUNT_ID
  name        = "Account Custom WAF Rules"
  description = "Custom WAF ruleset with security rules for the account"
  kind        = "custom"
  phase       = "http_request_firewall_custom"

  # Define your custom rules here
  rules = [
    {
      action      = "block"
      description = "Block non-standard ports (other than 80 and 443)"
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
      description = "Challenge suspicious User-Agents"
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
      description = "Log high threat score requests"
      enabled     = true
      expression  = "(cf.threat_score > 30)"
    }
  ]
}

# Step 2: Deploy the custom ruleset by updating the account-level root ruleset
resource "cloudflare_ruleset" "account_deploy_custom_rules" {
  account_id  = var.ACCOUNT_ID
  name        = "Account WAF Deployment"
  description = "Deploys custom WAF rules at account level"
  kind        = "root"
  phase       = "http_request_firewall_custom"

  # Rule to execute the custom ruleset for specific zones or all zones
  rules = [
    {
      action = "execute"
      action_parameters = {
        id = cloudflare_ruleset.account_custom_rules.id
      }
      description = "Execute custom rules for zxc.co.in zones"
      enabled     = true
      expression  = "(cf.zone.name contains \"zxc.co.in\")"
    }
    # You can add more deployment rules for different zones or conditions
    # Example: Deploy to all zones
    # {
    #   action = "execute"
    #   action_parameters = {
    #     id = cloudflare_ruleset.account_custom_rules.id
    #   }
    #   description = "Execute custom rules for all zones"
    #   enabled     = true
    #   expression  = "true"
    # }
  ]
}

################################################################################
# Outputs
################################################################################

output "custom_ruleset_id" {
  value       = cloudflare_ruleset.account_custom_rules.id
  description = "ID of the custom WAF ruleset"
}

output "deployment_ruleset_id" {
  value       = cloudflare_ruleset.account_deploy_custom_rules.id
  description = "ID of the deployment ruleset"
}

output "deployment_status" {
  value = <<-EOT
    Custom WAF Rules Deployed Successfully!
    
    Custom Ruleset ID: ${cloudflare_ruleset.account_custom_rules.id}
    Deployment ID: ${cloudflare_ruleset.account_deploy_custom_rules.id}
    
    The following rules are now active:
    - Block non-standard ports (other than 80 and 443)
    - Block US traffic to www.zxc.co.in
    - Challenge suspicious User-Agents
    - Log high threat score requests
    
    Applied to: Zones containing "zxc.co.in"
  EOT
  description = "Deployment status and summary"
}
