# module "mediaserver" {
#   source = "./vm-with-cf-and-ans"
#   name   = "mediaserver"

#   ipaddr  = "10.69.69.69"
#   gateway = "10.0.0.1"
#   cidr    = 8
#   dns1    = var.dns1
#   dns2    = var.dns2

#   memory            = 4096
#   secure_password   = var.secure_password
#   additional_groups = ["docker"]

#   proxmox_default_node = var.proxmox_default_node
#   proxmox_packer_vmid  = var.proxmox_packer_vmid
#   cf_domain            = var.cf_domain
#   cf_zone_id           = local.cf_zone_id
# }