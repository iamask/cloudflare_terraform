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

module "origin_rules" {
  source    = "./rules/origin_rules"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}



/*
available zone settings

{
    "result": [
        {
            "id": "0rtt",
            "value": "on",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "advanced_ddos",
            "value": "on",
            "modified_on": null,
            "editable": false
        },
        {
            "id": "always_online",
            "value": "off",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "always_use_https",
            "value": "on",
            "modified_on": "2022-11-28T08:24:35.003175Z",
            "editable": true
        },
        {
            "id": "automatic_https_rewrites",
            "value": "off",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "brotli",
            "value": "on",
            "modified_on": "2023-12-01T06:04:58.578056Z",
            "editable": true
        },
        {
            "id": "browser_cache_ttl",
            "value": 30,
            "modified_on": "2022-04-07T07:25:56.447131Z",
            "editable": true
        },
        {
            "id": "browser_check",
            "value": "on",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "cache_level",
            "value": "aggressive",
            "modified_on": "2022-05-04T06:43:37.927954Z",
            "editable": true
        },
        {
            "id": "challenge_ttl",
            "value": 300,
            "modified_on": "2023-09-14T09:17:00.456524Z",
            "editable": true
        },
        {
            "id": "ciphers",
            "value": [
                "ECDHE-ECDSA-AES128-GCM-SHA256",
                "ECDHE-ECDSA-CHACHA20-POLY1305",
                "ECDHE-RSA-AES128-GCM-SHA256",
                "ECDHE-RSA-CHACHA20-POLY1305",
                "ECDHE-ECDSA-AES256-GCM-SHA384",
                "ECDHE-RSA-AES256-GCM-SHA384"
            ],
            "modified_on": null,
            "editable": true
        },
        {
            "id": "cname_flattening",
            "value": "flatten_at_root",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "development_mode",
            "value": "off",
            "modified_on": "2023-06-27T04:12:36.929902Z",
            "time_remaining": 0,
            "editable": true
        },
        {
            "id": "early_hints",
            "value": "on",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "ech",
            "value": "off",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "edge_cache_ttl",
            "value": 7200,
            "modified_on": null,
            "editable": true
        },
        {
            "id": "email_obfuscation",
            "value": "on",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "filter_logs_to_cloudflare",
            "value": "off",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "hotlink_protection",
            "modified_on": null,
            "value": "off",
            "editable": true
        },
        {
            "id": "http2",
            "value": "on",
            "modified_on": "2024-03-22T11:18:21.850448Z",
            "editable": true
        },
        {
            "id": "http3",
            "value": "on",
            "modified_on": "2024-03-22T11:18:21.826709Z",
            "editable": true
        },
        {
            "id": "ip_geolocation",
            "value": "on",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "ipv6",
            "value": "on",
            "modified_on": "2024-12-09T04:51:34.720272Z",
            "editable": true
        },
        {
            "id": "log_to_cloudflare",
            "value": "on",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "long_lived_grpc",
            "value": "off",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "max_upload",
            "value": 100,
            "modified_on": null,
            "editable": true
        },
        {
            "id": "min_tls_version",
            "value": "1.2",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "minify",
            "value": {
                "css": "off",
                "html": "off",
                "js": "off"
            },
            "modified_on": "2024-10-08T05:49:04.199797Z",
            "editable": true
        },
        {
            "id": "mirage",
            "value": "on",
            "modified_on": "2023-03-30T08:24:29.511838Z",
            "editable": true
        },
        {
            "id": "mobile_redirect",
            "value": {
                "status": "off",
                "mobile_subdomain": null,
                "strip_uri": false
            },
            "modified_on": null,
            "editable": true
        },
        {
            "id": "opportunistic_encryption",
            "value": "off",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "opportunistic_onion",
            "value": "off",
            "modified_on": "2023-01-27T05:14:12.916219Z",
            "editable": true
        },
        {
            "id": "orange_to_orange",
            "value": "off",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "origin_error_page_pass_thru",
            "value": "off",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "polish",
            "value": "lossy",
            "modified_on": "2024-07-01T10:27:41.845165Z",
            "editable": true
        },
        {
            "id": "pq_keyex",
            "value": "on",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "prefetch_preload",
            "value": "on",
            "modified_on": "2023-07-28T04:02:34.867698Z",
            "editable": true
        },
        {
            "id": "privacy_pass",
            "value": "on",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "proxy_read_timeout",
            "value": "2",
            "modified_on": "2025-02-22T04:28:03.350254Z",
            "editable": true
        },
        {
            "id": "pseudo_ipv4",
            "value": "off",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "replace_insecure_js",
            "value": "off",
            "modified_on": "2024-09-28T03:46:41.024786Z",
            "editable": true
        },
        {
            "id": "response_buffering",
            "value": "off",
            "modified_on": "2024-09-28T03:56:19.215063Z",
            "editable": true
        },
        {
            "id": "rocket_loader",
            "value": "off",
            "modified_on": "2023-07-28T04:02:41.571035Z",
            "editable": true
        },
        {
            "id": "security_header",
            "modified_on": "2024-09-01T12:38:58.959207Z",
            "value": {
                "strict_transport_security": {
                    "enabled": true,
                    "max_age": 2592000,
                    "include_subdomains": false,
                    "preload": false,
                    "nosniff": false
                }
            },
            "editable": true
        },
        {
            "id": "security_level",
            "value": "medium",
            "modified_on": "2022-05-27T11:01:58.565989Z",
            "editable": true
        },
        {
            "id": "server_side_exclude",
            "value": "on",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "sort_query_string_for_cache",
            "value": "off",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "ssl",
            "value": "full",
            "modified_on": "2024-07-05T06:44:58.960389Z",
            "certificate_status": "deleted",
            "validation_errors": [],
            "editable": true
        },
        {
            "id": "tls_1_2_only",
            "value": "off",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "tls_1_3",
            "value": "zrt",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "tls_client_auth",
            "value": "off",
            "modified_on": "2024-12-06T15:00:05.210660Z",
            "editable": true
        },
        {
            "id": "true_client_ip_header",
            "value": "on",
            "modified_on": "2022-02-15T05:14:11.382968Z",
            "editable": true
        },
        {
            "id": "visitor_ip",
            "value": "on",
            "modified_on": null,
            "editable": true
        },
        {
            "id": "waf",
            "value": "on",
            "modified_on": "2021-11-23T11:27:12.718327Z",
            "editable": true
        },
        {
            "id": "webp",
            "value": "on",
            "modified_on": "2024-07-01T10:27:42.593916Z",
            "editable": true
        },
        {
            "id": "websockets",
            "value": "on",
            "modified_on": null,
            "editable": true
        }
    ],
    "success": true,
    "errors": [],
    "messages": []
}
*/