resource "cloudflare_ruleset" "single_redirects_example" {
  zone_id     = var.ZONE_ID
  name        = "Single Redirect Rule"
  description = "Redirect visitors still using old URL"
  kind        = "zone"
  phase       = "http_request_dynamic_redirect"

  rules = [{
    action = "redirect"
    action_parameters = {
      status_code = 400  # Changed from 301 to 302
      target_url  = "/contacts/"
      preserve_query_string = false
    }
    expression  = "(http.request.uri.path matches \"^/contact-us/\")"
    description = "Redirect visitors still using old URL"
    enabled     = true
  }]
}
