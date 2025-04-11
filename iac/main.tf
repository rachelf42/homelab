# vim: set tabstop=2
terraform {
  cloud {
    organization = "RachelF42-Homelab"
    workspaces { name = "Cloudflare" }
  }
  required_version = "~>1.11, >=1.11.3"
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "~>1.3"
    }
  }
}
variable "dev_machine_ip" {
  type = string
}
resource "ansible_vault" "vault" {
  vault_file          = "./ansible/vault.yaml"
  vault_password_file = "./ansible/vault-pass-helper.sh"
}
locals {
  vault = yamldecode(ansible_vault.vault.yaml)
}
