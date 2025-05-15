# This file is for anything that should be outside of the high-availablity group
# like monitors, CICD, that kinda thing
# I use an old busted up laptop for this but you could use an SBC or smth

module "jenkins" {
  source = "./vm-with-cf-and-ans"
  name   = "jenkins"

  ipaddr  = "10.69.69.254"
  gateway = "10.0.0.1"
  cidr    = 8
  dns1    = var.dns1
  dns2    = var.dns2

  memory            = 2048
  secure_password   = var.secure_password
  additional_groups = ["jenk"] # bad idea to have a host and group with the same name, want to have a group for futureproofing

  proxmox_default_node = "pve-laptop"
  proxmox_packer_vmid  = var.proxmox_packer_vmid
  cf_domain            = var.cf_domain
  cf_zone_id           = local.cf_zone_id
}