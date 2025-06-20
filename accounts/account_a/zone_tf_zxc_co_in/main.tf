# Zone Settings Module
module "zone_settings" {
  source    = "./zone_settings/zone_settings"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}

# DNS Module
module "dns" {
  source    = "./dns/dns"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}

# Custom Rules Module
module "custom_rules" {
  source    = "./security/custom_rules"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}

# Managed Rules Module
module "managed_rules" {
  source    = "./security/managed_rules"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}

# Rate Limit Module
module "rate_limit" {
  source    = "./security/rate_limit"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}

# Cache Rules Module
module "cache_rules" {
  source    = "./rules/cache_rules"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}

# Transform Rules Module
module "transform_rules" {
  source    = "./rules/transform_rules"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}

# Redirect Rules Module
module "redirect_rules" {
  source    = "./rules/redirect_rules"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}

# Origin Rules Module
module "origin_rules" {
  source    = "./rules/origin_rules"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}

# Custom Hostnames Module
module "custom_hostnames" {
  source    = "./tls/custom_hostnames"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}
