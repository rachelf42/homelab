data "publicip_address" "ip" {}
resource "cloudflare_dns_record" "root" {
  content = data.publicip_address.ip.ip
  name    = var.cf_domain
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = local.cf_zone_id
}
resource "cloudflare_dns_record" "wildcard" {
  content = var.cf_domain
  name    = "*.${var.cf_domain}"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cf_zone_id
}
resource "cloudflare_dns_record" "local" {
  content = "10.69.69.69"
  name    = "local.${var.cf_domain}"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = local.cf_zone_id
}
resource "cloudflare_dns_record" "local-wildcard" {
  content = "local.${var.cf_domain}"
  name    = "*.local.${var.cf_domain}"
  proxied = false
  ttl     = 1
  type    = "CNAME"
  zone_id = local.cf_zone_id
}
