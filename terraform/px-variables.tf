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
variable "proxmox_default_node" {
  type = string
}
variable "proxmox_packer_vmid" {
  type    = number
  default = 9000
}
variable "secure_password" {
  type      = string
  sensitive = true
}
variable "px_cftoken" {
  type      = string
  sensitive = true
}
variable "dns1" {
  type    = string
  default = "1.1.1.1"
}
variable "dns2" {
  type    = string
  default = "1.0.0.1"
}
variable "pve-nodes" {
  type    = set(string)
  default = []
}