# Single Redirects resource
resource "cloudflare_ruleset" "single_redirects_example" {
  zone_id     = var.ZONE_ID
  name        = "redirects"
  description = "Redirects ruleset"
  kind        = "zone"
  phase       = "http_request_dynamic_redirect"

  rules = [{
  "description": "tf_Redirec",
  "expression": "(http.host wildcard \"red.zxc.co.in\" and http.request.uri.path wildcard r\"/this\")",
  "action": "redirect",
  "action_parameters": {
    "from_value": {
      "status_code": 301,
      "preserve_query_string": true,
      "target_url": {
        "value": "/that214"
      }
    }
  },
  "enabled": true
}
]
}
