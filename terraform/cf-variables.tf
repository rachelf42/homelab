data "cloudflare_zones" "cf_domain" {
  name   = var.cf_domain
  status = "active"
}
variable "cf_domain" {
  type = string
}
variable "cf_account_id" {
  type      = string
  sensitive = true
}
variable "cf_api_token" {
  type      = string
  sensitive = true
}
locals {
  cf_zone_id = one(data.cloudflare_zones.cf_domain.result).id
}