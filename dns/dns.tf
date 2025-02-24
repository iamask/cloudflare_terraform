resource "cloudflare_dns_record" "wwe" {
  zone_id = var.ZONE_ID
  name    = "wwe"
  content   = "34.93.22.64"
  type    = "A"
  proxied = true
  ttl = 1 
}

resource "cloudflare_dns_record" "fallback" {
  zone_id = var.ZONE_ID
  name    = "fallback"
  content   = "34.93.22.64"
  type    = "A"
  proxied = true
  ttl = 1 
}


resource "cloudflare_dns_record" "wildcard" {
  zone_id = var.ZONE_ID
  name    = "*"
  content   = "34.93.22.64"
  type    = "A"
  proxied = true
  ttl = 1 
}

resource "cloudflare_dns_record" "delhi" {
  zone_id = var.ZONE_ID
  name    = "delhi"
  content   = "34.131.175.140"
  type    = "A"
  proxied = true
  ttl = 1 
}


resource "cloudflare_dns_record" "api" {
  zone_id = var.ZONE_ID
  name    = "api"
  content   = "34.131.175.40"
  type    = "A"
  proxied = true
  ttl = 1 
}


resource "cloudflare_dns_record" "api2" {
  zone_id = var.ZONE_ID
  name    = "api2"
  content   = "34.131.175.40"
  type    = "A"
  proxied = true
  ttl = 1 
}



