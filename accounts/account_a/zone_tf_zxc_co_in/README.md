# Cloudflare Terraform: Account/Zone Structure

This directory follows Cloudflare's recommended best practices for Terraform, organizing resources by account and zone.

## Structure

```
accounts/
  account_a/
    zone_tf_zxc_co_in/
      dns/
        dns/
          main.tf, variables.tf, versions.tf
      security/
        custom_rules/
        managed_rules/
        rate_limit/
      rules/
        cache_rules/
        transform_rules/
        redirect_rules/
        origin_rules/
      tls/
        custom_hostnames/
      zone_settings/
        zone_settings/
      main.tf           # Composes all modules for this zone
      variables.tf      # Zone-level variables
      README.md         # This file
```

## Usage

1. `cd accounts/account_a/zone_tf_zxc_co_in`
2. `terraform init`
3. `terraform plan`
4. `terraform apply`

## Why this structure?

- **Isolation:** Each account and zone is managed independently, reducing risk.
- **Clarity:** All resources for a zone are grouped together.
- **Best Practice:** Matches [Cloudflare's official guidance](https://developers.cloudflare.com/terraform/advanced-topics/best-practices/).

## Adding More Accounts/Zones

- Create a new directory under `accounts/` for each account.
- Add a new zone directory for each zone within the account.
- Copy the product module folders as needed.

## Example

To add another zone for `account_a`, create:

```
accounts/account_a/zone_example_com/
```

And repeat the structure above.

---

For more, see [Cloudflare's best practices](https://developers.cloudflare.com/terraform/advanced-topics/best-practices/).
