terraform {
  required_version = "1.11.4"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.3.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.77.0"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
    publicip = {
      source  = "nxt-engineering/publicip"
      version = "0.0.9"
    }
  }
}
provider "cloudflare" {
  api_token = var.cf_api_token
}
provider "proxmox" {
  endpoint      = var.proxmox_api_url
  api_token     = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  random_vm_ids = true
  insecure      = var.proxmox_is_insecure
}

# dummy variable declarations to silence warnings about packer vars
variable "proxmox_iso_storage" {
  type = string
}
variable "proxmox_storage" {
  type = string
}