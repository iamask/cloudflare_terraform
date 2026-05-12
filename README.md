# Cloudflare Terraform Configuration

Enterprise zone and account-level configuration using Terraform Provider v5. State managed by Terraform Cloud with GitHub Actions CI/CD.

## 📁 Project Structure

```
cloudflare_terraform/
├── main.tf                           # Root config (provider, variables, module refs)
├── terraform.tfvars.example          # Example variables (never commit real values)
├── .github/workflows/terraform.yml   # CI/CD: plan on PR, apply on merge to main
├── accounts/
│   ├── account_a/
│   │   ├── custom_rulesets/         # Account-level custom WAF rules
│   │   ├── waf_managed_rulesets/    # Cloudflare & OWASP managed rulesets
│   │   ├── ratelimit_rulesets/      # Account-level rate limiting
│   │   └── zone_tf_zxc_co_in/      # Zone-specific configuration
│   │       ├── dns/                 # DNS records
│   │       ├── security/            # WAF, custom rules, rate limiting
│   │       ├── rules/               # Transform, redirect, cache, origin rules
│   │       ├── tls/                 # SSL/TLS settings (custom hostnames)
│   │       └── zone_settings/       # Zone-level settings
│   └── account_b/                   # Additional account (to be defined)
```

> **Note:** Additional accounts can be configured similarly under the `accounts/` directory to manage multi-account deployments.

## 🚀 Features

**Account-Level:**
- Custom WAF rulesets (split by purpose: security, API protection)
- Managed WAF (Cloudflare Managed Ruleset & OWASP Core Ruleset)
- Rate limiting rules

**Zone-Level:**
- DNS management
- Security (WAF custom rules, managed rules, rate limiting)
- Rules (transform, redirect, cache, origin)
- TLS/SSL configuration (custom hostname fallback origin)
- Zone settings (HTTPS, HTTP/2, HTTP/3, IPv6)

## 📋 Requirements

- Terraform >= 1.5.0
- Cloudflare Provider ~> 5.0 (latest stable: v5.19.1)
- Cloudflare API Token ([Create Token](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/))
- Account ID & Zone ID ([Find IDs](https://developers.cloudflare.com/fundamentals/setup/find-account-and-zone-ids/))

## 🔧 Quick Start

```bash
# Clone repository
git clone <repository-url>

# Copy example vars (fill in your values)
cp terraform.tfvars.example terraform.tfvars

# Initialize Terraform (connects to Terraform Cloud)
terraform init

# Review changes
terraform plan

# Apply configuration
terraform apply
```

## 🏗️ Architecture Decisions

**Provider inheritance:** The `cloudflare` provider is configured once in root `main.tf`. All modules inherit it automatically — no need to pass `API_TOKEN` to each module.

**Module structure:** Modules are used for organizational grouping only. Each module receives only the variables it needs (`ZONE_ID` for zone modules, `ACCOUNT_ID` for account modules).

**CI/CD:** GitHub Actions runs `terraform plan` on PRs (with plan output as a comment) and `terraform apply` on merge to `main`. Deployment is never done manually via `wrangler deploy`.

## ⚠️ Important Note

**Ruleset Modification Behavior**: 

✅ **In-place updates** (no downtime):
- Modifying rule expressions (e.g., changing hostnames)
- Updating descriptions or enabled status
- Simple property changes within existing rules

❌ **Full replacement** (brief disruption):
- Adding or removing rules from the array
- Changing fundamental properties (kind, phase)
- Major structural changes to the ruleset

```hcl
# Example: Expression changes = UPDATE
expression = "host eq \"api.example.com\"" → "host eq \"api2.example.com\""  # ✅ In-place update

# Example: Adding/removing rules = REPLACE
rules = [
  { action = "block", ... },  # Existing
  { action = "log", ... }     # ← Adding new rule causes replacement
]
```

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
- [Cloudflare Terraform Best Practices](https://developers.cloudflare.com/terraform/advanced-topics/best-practices/)
