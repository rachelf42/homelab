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

variable "hcp_token" {
  type = string
  sensitive = true
  nullable = true
  default = null
}
data "tfe_outputs" "bootstrap" {
  organization = "rachelf42"
  workspace = "bootstrap"
}
locals {
  cf_zone_id = data.tfe_outputs.bootstrap.nonsensitive_values.cf_zone_id
}