### NETWORK INFRASTRUCTURE
resource "cloudflare_dns_record" "pve" {
  content = "10.69.69.1" # TODO: setup some kinda loadbalancer for future expansion
                         # label: waiting
                         # Issue URL: https://github.com/rachelf42/homelab/issues/25
  name    = "pve.local.${var.cf_domain}"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = local.cf_zone_id
}
### BAREMETAL SERVERS
module "baremetal" {
  for_each        = tomap(var.ansible_statics)
  source          = "./cloudflare-and-ansible-host"
  name            = each.key
  groups          = each.value.groups
  ipaddr          = each.value.ipaddr
  ansible_user    = each.value.ansible_user
  ansible_keyfile = each.value.ansible_keyfile
  user_name       = each.value.user_name != null ? each.value.user_name : "rachel"
  homedir         = each.value.homedir != null ? each.value.homedir : "/home/rachel"
  cf_domain       = var.cf_domain
  cf_zone_id      = local.cf_zone_id
}
### META GROUPS
resource "ansible_group" "by_type" {
  name     = "by_type"
  children = ["vm", "lxc", "baremetal"]
}
resource "ansible_group" "by_os" {
  name     = "by_os"
  children = ["ubuntu", "debian"]
}
resource "ansible_group" "by_role" {
  name = "by_role"
  children = [
    "docker",
    "pve",
    "nas",
    "devmachine",
    "server",
    "jenk"
  ]
}
