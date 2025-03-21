This is a basic template to get started with Cloudflare after onboarding an Enterprise zone. State file is stored in terraform Cloud and integrated with Github actions.

This uses Terraform Cloudflare Provider Version 5

- https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/guides/version-5-upgrade

**Template will update** :

- Zone level setting
- DNS
- WAF Managed rules
- Custom rules
- Rate limiting
- Transform rules
- Redirect rules
- Cache rules

#NXT

- Zero Trust
- Cloudflare Access

  **Reference** :

  - https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs
  - https://developers.cloudflare.com/terraform/

  **Steps**:

- clone the repo
- run > "Terraform init"
- run > "Terraform plan"
- run > "Terraform apply"

- **Note**: Terraform plan and apply command will prompt for API token and zone ID

  **Reference**

- https://developers.cloudflare.com/fundamentals/api/get-started/create-token/
- https://developers.cloudflare.com/fundamentals/setup/find-account-and-zone-ids/
