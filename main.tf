# Root configuration that references the zone-specific configuration
# This file is used by Terraform Cloud to find the actual configuration

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

terraform {
  cloud {
    organization = "iamask"
    workspaces {
      name = "cloudflare"
    }
  }
}

provider "cloudflare" {
  api_token = var.API_TOKEN
}

# Variable declarations
variable "API_TOKEN" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "ZONE_ID" {
  description = "Cloudflare Zone ID"
  type        = string
}

# Reference the zone-specific configuration
module "tf_zxc_co_in" {
  source = "./accounts/account_a/zone_tf_zxc_co_in"

  # Pass through the variables
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}
