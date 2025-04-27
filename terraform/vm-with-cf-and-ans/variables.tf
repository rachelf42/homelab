variable "name" {
  type = string
}
variable "ipaddr" {
  type = string
}
variable "cf_domain" {
  type = string
}
variable "cf_zone_id" {
  type = string
}
variable "proxmox_default_node" {
  type = string
}
variable "proxmox_packer_vmid" {
  type = string
}
variable "secure_password" {
  type      = string
  sensitive = true
}
variable "dns1" {
  type = string
}
variable "dns2" {
  type = string
}
variable "cidr" {
  type = number
}
variable "gateway" {
  type = string
}
variable "additional_tags" {
  type    = set(string)
  default = []
}
variable "additional_groups" {
  type    = set(string)
  default = []
}
variable "user_name" {
  type    = string
  default = "rachel"
}
variable "memory" {
  type = number
}
variable "memfloat" {
  type     = number
  default  = null
  nullable = true
}
variable "cores" {
  type    = number
  default = 1
}