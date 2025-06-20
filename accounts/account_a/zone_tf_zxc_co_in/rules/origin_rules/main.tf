resource "cloudflare_ruleset" "http_origin_noisy" {
  zone_id     = var.ZONE_ID
  name        = "Origin rule"
  description = "Origin Ruleset"
  kind        = "zone"
  phase       = "http_request_origin"

  rules = [{
    action = "route"
    action_parameters = {
      origin = {
        host = "delhi.tf.zxc.co.in"
      }
    }
    expression  = "lookup_json_string(cf.hostname.metadata, \"customer_noise\") == \"high\""
    description = "Change origins for noisy customers"
    enabled     = true
  }]
} 
