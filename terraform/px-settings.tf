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
resource "proxmox_virtual_environment_user_token" "homepage" {
  token_name = "homepage"
  user_id    = proxmox_virtual_environment_user.mine.user_id
}
data "proxmox_virtual_environment_role" "auditor" {
  role_id = "PVEAuditor"
}
resource "proxmox_virtual_environment_acl" "homepage" {
  token_id  = proxmox_virtual_environment_user_token.homepage.id
  role_id   = data.proxmox_virtual_environment_role.auditor.role_id
  path      = "/"
  propagate = true
}