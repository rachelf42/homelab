terraform {
  required_version = "1.12.1"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.4.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.78.1"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
  }
  cloud {
    organization = "rachelf42"
    workspaces {
      name = "bootstrap"
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

# dummy variable declarations to silence warnings about unused vars
variable "px_cftoken" {}
variable "pve-nodes" {}
variable "cf_account_id" {}
variable "proxmox_iso_storage" {}
variable "proxmox_storage" {}
variable "email" {}
