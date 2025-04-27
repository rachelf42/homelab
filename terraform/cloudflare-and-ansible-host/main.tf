terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    ansible = {
      source = "ansible/ansible"
    }
  }
}
resource "ansible_host" "host" {
  name   = var.name
  groups = var.groups
  variables = {
    homedir    = var.homedir != null ? var.homedir : "/home/${var.user_name}"
    repodir    = var.repodir != null ? var.repodir : var.homedir != null ? "${var.homedir}/homelab" : "/home/${var.user_name}/homelab"
    ip_address = var.ipaddr
    user_name  = var.user_name

    ansible_python_interpreter = "/usr/bin/python3"
    ansible_private_key_file   = var.ansible_keyfile != null ? var.ansible_keyfile : "./sshkey", # relative to /ansible 
    ansible_user               = var.ansible_user != null ? var.ansible_user : var.user_name
  }
}
resource "cloudflare_dns_record" "dns" {
  name    = "${var.name}.local.${var.cf_domain}"
  content = var.ipaddr
  proxied = false
  ttl     = 1
  type    = "A"
  zone_id = var.cf_zone_id
}
