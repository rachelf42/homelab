# vim: set tabstop=2
# vim: filetype=json
resource "cloudflare_dns_record" "root" {
  content = "24.68.237.7"
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
resource "cloudflare_dns_record" "rachel-pc" {
  content = "10.69.1.69"
  name    = "rachel-pc.local.${var.cf_domain}"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = local.cf_zone_id
}
resource "cloudflare_dns_record" "pve" {
  content = "10.69.69.1"
  name    = "pve.local.${var.cf_domain}"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = local.cf_zone_id
}
resource "cloudflare_dns_record" "nas1" {
  content = "10.69.69.2"
  name    = "nas1.local.${var.cf_domain}"
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
