resource "proxmox_virtual_environment_cluster_options" "opts" {
  language = "en"
  keyboard = "en-us"
}
data "proxmox_virtual_environment_acme_accounts" "acme" {}
# TODO: feature request for `pvenode config set --acme` so i can move that into here and uncomment this
# resource "proxmox_virtual_environment_acme_dns_plugin" "cloudflare" {
#   lifecycle {
#     precondition {
#       condition     = length(data.proxmox_virtual_environment_acme_accounts.acme.accounts) > 0
#       error_message = "No ACME Accounts Exist!"
#     }
#   }
#   plugin = "cloudflare"
#   api    = "cf"
#   data = {
#     CF_Account_ID = var.cf_account_id
#     CF_Token      = var.px_cftoken
#   }
# }
resource "proxmox_virtual_environment_dns" "dnsconfig" {
  for_each  = var.pve-nodes
  node_name = each.value
  domain    = "local.${var.cf_domain}"
  servers = [
    var.dns1,
    var.dns2
  ]
}