resource "proxmox_virtual_environment_cluster_options" "opts" {
  language = "en"
  keyboard = "en-us"
}
resource "proxmox_virtual_environment_dns" "dnsconfig" {
  for_each  = var.pve-nodes
  node_name = each.value
  domain    = "local.${var.cf_domain}"
  servers = [
    var.dns1,
    var.dns2
  ]
}

resource "proxmox_virtual_environment_user" "mine" {
  user_id  = "rachel@pve"
  email    = var.email
  password = var.secure_password
  acl {
    path      = "/"
    propagate = true
    role_id   = "Administrator"
  }
}

resource "proxmox_virtual_environment_user_token" "homarr" {
  token_name = "homarr"
  user_id = proxmox_virtual_environment_user.mine.user_id
}
resource "proxmox_virtual_environment_acl" "homarr" {
  token_id = proxmox_virtual_environment_user_token.homarr.id
  role_id = "PVEAuditor"
  path = "/"
  propagate = true
}
output "homarr_proxmox_secret" {
  sensitive = true
  value = proxmox_virtual_environment_user_token.homarr.value
}