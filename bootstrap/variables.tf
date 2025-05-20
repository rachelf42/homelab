variable "proxmox_api_token_id" {
  type = string
}
variable "proxmox_api_token_secret" {
  type      = string
  sensitive = true
}
variable "proxmox_api_url" {
  type = string
}
variable "proxmox_is_insecure" {
  type    = bool
  default = true
}
variable "dns1" {
  type    = string
  default = "1.1.1.1"
}
variable "dns2" {
  type    = string
  default = "1.0.0.1"
}
variable "secure_password" {
  type      = string
  sensitive = true
}
variable "proxmox_packer_vmid" {
  type    = number
  default = 9000
}
variable "proxmox_default_node" {
  type = string
}
data "proxmox_virtual_environment_vm" "template-vm-ubuntu-noble" {
  node_name = var.proxmox_default_node
  vm_id     = var.proxmox_packer_vmid
}


variable "cf_api_token" {
  type      = string
  sensitive = true
}
variable "cf_domain" {
  type = string
}
data "cloudflare_zones" "cf_domain" {
  name   = var.cf_domain
  status = "active"
}
locals {
  cf_zone_id = one(data.cloudflare_zones.cf_domain.result).id
}
output "cf_zone_id" {
  value = local.cf_zone_id
}