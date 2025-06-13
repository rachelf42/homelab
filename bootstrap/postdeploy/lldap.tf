data "lldap_groups" "groups" {}
locals {
  groups = {for each in data.lldap_groups.groups.groups : each.display_name => each}
}
resource "lldap_group" "nas_access" {
  display_name = "nas_access"
}
resource "lldap_group" "users" {
  display_name = "all_users"
}
resource "lldap_group" "admin" {
  display_name = "admin"
}
# MY USER
resource "lldap_user" "mine" {
  username = "rachel"
  email = jsondecode(file("${path.module}/usercreds.json")).email
  password = jsondecode(file("${path.module}/usercreds.json")).password
  display_name = "Rachel"
}
resource "lldap_user_memberships" "mine" {
  user_id = lldap_user.mine.id
  group_ids = [
    local.groups.lldap_admin.id,
    lldap_group.admin.id,
    lldap_group.users.id,
    lldap_group.nas_access.id
  ]
}
# AUTHELIA
resource "lldap_user" "authelia" {
  username = "authelia"
  email = "authelia@localhost"
  password = file("${path.module}/authelia-ldap-password")
  display_name = "Authelia System User"
}
resource "lldap_user_memberships" "authelia" {
  user_id = lldap_user.authelia.id
  group_ids = [
    local.groups.lldap_strict_readonly.id
  ]
}