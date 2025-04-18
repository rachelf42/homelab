terraform {
  required_version = "1.11.4"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.3.0"
    }
  }
}
provider "cloudflare" {
  api_token = var.cf_api_token
}
