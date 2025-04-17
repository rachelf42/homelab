# vim: set tabstop=2
# vim: filetype=json
terraform {
  required_version = "1.11.4"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.75.0"
    }
    ansible = { # found it easier to keep PM config and inventory entries together
      source  = "ansible/ansible"
      version = "1.3.0"
    }
  }
}
provider "proxmox" {
  endpoint      = var.proxmox_api_url
  api_token     = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  random_vm_ids = true
  insecure      = var.proxmox_is_insecure
}
