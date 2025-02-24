resource "cloudflare_ruleset" "cache_rules_example" {
  zone_id     = var.ZONE_ID
  name        = "Set cache settings"
  description = "Set cache settings for incoming requests"
  kind        = "zone"
  phase       = "http_request_cache_settings"

  rules = [
    {
      ref         = "cache_settings_custom_cache_key"
      description = "Set cache settings and custom cache key for api.tf.zxc.co.in"
      expression  = "(http.host eq \" api.tf.zxc.co.in\")"
      action      = "set_cache_settings"

      action_parameters = {
        edge_ttl = {
          mode    = "override_origin"
          default = 60

          status_code_ttl = [
            {
              status_code = 200  # Fixed: status_code should be a single number
              value       = 50
            }
          ]
        }

        browser_ttl = {
          mode = "respect_origin"
        }

        origin_error_page_passthru = false
      }
    }
  ]
}
