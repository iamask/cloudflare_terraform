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



module "dns" {
  source    = "./dns"
  API_TOKEN = var.API_TOKEN
  ZONE_ID   = var.ZONE_ID
}

