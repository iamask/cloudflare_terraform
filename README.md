# Cloudflare Terraform Configuration

Enterprise zone and account-level configuration using Terraform Provider v5. State managed by Terraform Cloud with GitHub Actions integration.

## 📁 Project Structure

```
cloudflare_terraform/
├── main.tf                           # Root configuration
├── terraform.tfvars.example          # Example variables
├── accounts/
│   ├── account_a/
│   │   ├── custom_rulesets/         # Account-level custom WAF rules
│   │   ├── ratelimit_rulesets/      # Account-level rate limiting
│   │   └── zone_tf_zxc_co_in/       # Zone-specific configuration
│   │       ├── dns/                 # DNS records
│   │       ├── security/            # WAF, custom rules, rate limiting
│   │       ├── rules/               # Transform, redirect, cache rules
│   │       ├── tls/                 # SSL/TLS settings
│   │       └── zone_settings/       # Zone-level settings
│   └── account_b/                   # Additional account configuration
│       └── main.tf                  # Account B configuration (to be defined)
```

> **Note:** Additional accounts can be configured similarly under the `accounts/` directory to manage multi-account deployments.

## 🚀 Features

**Account-Level:**
- Custom WAF rulesets
- Rate limiting rules

**Zone-Level:**
- DNS management
- Security (WAF, custom rules, rate limiting)
- Rules (transform, redirect, cache, origin)
- TLS/SSL configuration
- Zone settings

## 📋 Requirements

- Terraform >= 1.5.0
- Cloudflare Provider ~> 5.0
- Cloudflare API Token ([Create Token](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/))
- Account ID & Zone ID ([Find IDs](https://developers.cloudflare.com/fundamentals/setup/find-account-and-zone-ids/))

## 🔧 Quick Start

```bash
# Clone repository
git clone <repository-url>

# Initialize Terraform
terraform init

# Review changes
terraform plan

# Apply configuration
terraform apply
```

## ⚠️ Important Warning

**Ruleset Modification Behavior**: Any change to the `rules` array in Cloudflare rulesets causes Terraform to replace the entire ruleset (delete & recreate).

```hcl
# Example: Adding/removing/modifying ANY rule causes full replacement
rules = [
  { action = "block", expression = "..." },  # Existing rule
  { action = "log", expression = "..." }     # ← Adding this replaces entire ruleset
]
```

This applies to both custom rulesets and entrypoint rulesets, causing brief traffic disruption during replacement.

### 💡 Mitigation Strategies

**1. Use Multiple Smaller Rulesets**
```hcl
# Instead of one large ruleset, split by purpose
resource "cloudflare_ruleset" "security_rules" { ... }     # Security-focused rules
resource "cloudflare_ruleset" "api_rules" { ... }          # API protection rules
resource "cloudflare_ruleset" "geo_rules" { ... }          # Geo-blocking rules
# Changes to one ruleset won't affect others
```

**2. Use Lifecycle Meta-Argument**
```hcl
resource "cloudflare_ruleset" "account_custom_ruleset" {
  # ... ruleset configuration ...
  
  lifecycle {
    create_before_destroy = true  # Creates new ruleset before destroying old one
  }
}
# Minimizes downtime during replacement
```

## 📚 References

- [Cloudflare Provider Docs](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs)
- [Terraform + Cloudflare Guide](https://developers.cloudflare.com/terraform/)
