terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"

    }

  }
}

# remove this block to store the state file locally
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


resource "cloudflare_zone_setting" "tf_zone_setting" {
  zone_id = var.ZONE_ID
  setting_id = "always_online"
  id = "0rtt"
  value = "on"
}

resource "cloudflare_hostname_tls_setting" "tf_zone_tls_setting" {
  zone_id = var.ZONE_ID
  setting_id = "ciphers"
  hostname = "app.example.com"
  value = ["ECDHE-RSA-AES128-GCM-SHA256", "AES128-GCM-SHA256"]
}


module "dns" {
  source    = "./dns"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}


module "managed_rules" {
  source    = "./security/managed_rules"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}

module "rate_limit_rules" {
  source    = "./security/rate_limit"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}

module "custom_rules" {
  source    = "./security/custom_rules"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}

module "cache_rules" {
  source    = "./rules/cache_rules"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}


module "transform_rules" {
  source    = "./rules/transform_rules"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}

module "redirect_rules" {
  source    = "./rules/redirect_rules"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}
