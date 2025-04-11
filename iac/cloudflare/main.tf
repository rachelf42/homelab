# vim: set tabstop=2
# vim: filetype=json
terraform {
  required_version = "~>1.11, >=1.11.3"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.2"
    }
  }
}
provider "cloudflare" {
  api_token = var.cf_api_token
}
