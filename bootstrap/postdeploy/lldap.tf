data "lldap_groups" "groups" {}
locals {
  groups = {for each in data.lldap_groups.groups : lookup(each, "display_name", "UNKNOWN") => each}
}
output "groupsFound" {
  value = local.groups
}