resource "ansible_group" "nomad" {
  name     = "nomad"
  children = ["nomad_server", "nomad_client"]
  variables = {
    nomad_svrcount = length(var.nomad_nodes)
  }
}
resource "cloudflare_dns_record" "nomad" {
  content = "10.69.70.254" # TODO load balancer
  name    = "nomad.local.${var.cf_domain}"
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = local.cf_zone_id
}
module "nomad-server" {
  count  = length(var.nomad_nodes)
  source = "./vm-with-cf-and-ans"

  cores  = 1
  memory = var.nomad_reserved_memory

  cf_domain            = var.cf_domain
  cf_zone_id           = local.cf_zone_id
  proxmox_default_node = var.nomad_nodes[count.index].name
  proxmox_packer_vmid  = var.proxmox_packer_vmid
  secure_password      = var.secure_password

  additional_tags   = ["nomad-server"]
  additional_groups = ["nomad_server"]
  dns1              = var.dns1
  dns2              = var.dns2
  gateway           = "10.0.0.1"
  cidr              = 8

  name   = "nomad-${var.nomad_nodes[count.index].name}"
  ipaddr = "10.69.70.${254 - count.index}"
}
module "nomad-client" {
  count  = length(var.nomad_nodes)
  source = "./vm-with-cf-and-ans"

  cores  = var.nomad_nodes[count.index].cores - 2                          # one for proxmox itself, one for the server vm
  memory = var.nomad_nodes[count.index].memory - var.nomad_reserved_memory # no times two because ballooning on by default

  cf_domain            = var.cf_domain
  cf_zone_id           = local.cf_zone_id
  proxmox_default_node = var.nomad_nodes[count.index].name
  proxmox_packer_vmid  = var.proxmox_packer_vmid
  secure_password      = var.secure_password

  additional_tags   = ["nomad-client"]
  additional_groups = ["nomad_client", "docker"]
  dns1              = var.dns1
  dns2              = var.dns2
  gateway           = "10.0.0.1"
  cidr              = 8

  name   = "nomad-client-${var.nomad_nodes[count.index].name}"
  ipaddr = "10.69.70.${1 + count.index}"
}
