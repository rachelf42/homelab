resource "cloudflare_dns_record" "pve" { # TODO: setup some kinda loadbalancer for future expansion
  content = "10.69.69.1"
  name    = "pve.local.${var.cf_domain}"
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
resource "cloudflare_dns_record" "pve-laptop" {
  content = "10.69.69.1"
  name    = "pve-laptop.local.${var.cf_domain}"
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