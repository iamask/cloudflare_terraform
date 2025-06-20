# Zone Settings
resource "cloudflare_zone_setting" "always_use_https_zone_setting" {
  zone_id    = var.ZONE_ID
  setting_id = "always_use_https"
  value      = "on"
}

resource "cloudflare_zone_setting" "http2_zone_setting" {
  zone_id    = var.ZONE_ID
  setting_id = "http2"
  value      = "on"
}

resource "cloudflare_zone_setting" "http3_zone_setting" {
  zone_id    = var.ZONE_ID
  setting_id = "http3"
  value      = "on"
}

resource "cloudflare_zone_setting" "ipv6_zone_setting" {
  zone_id    = var.ZONE_ID
  setting_id = "ipv6"
  value      = "on"
} 
