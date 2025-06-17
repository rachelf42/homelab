terraform {
  required_version = ">= 1.12.1, < 2.0.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.5.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.78.1"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
    publicip = {
      source  = "nxt-engineering/publicip"
      version = "0.0.9"
    }
    tfe = {
      version = "0.66.0"
    }
    webhookrelay = {
      source  = "koalificationio/webhookrelay"
      version = "0.2.0"
    }
  }
  cloud {
    organization = "rachelf42"
    workspaces {
      name = "homelab"
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
provider "tfe" {
  token = var.hcp_token == null ? file("${path.module}/hcp_token") : var.hcp_token
}
provider "webhookrelay" {
  api_key    = var.webhookrelay_key
  api_secret = var.webhookrelay_secret
}

# dummy variable declarations to silence warnings about packer vars
variable "proxmox_iso_storage" {
  type = string
}
variable "proxmox_storage" {
  type = string
}
