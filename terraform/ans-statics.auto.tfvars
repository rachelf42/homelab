ansible_statics = {
  "rachel-pc" = {
    "ansible_keyfile" = "~/.ssh/id_ed25519",
    "groups"          = ["baremetal", "ubuntu", "devmachine"],
    "ipaddr"          = "10.69.1.69"
  },
  "pve-laptop" = {
    "groups" = ["baremetal", "debian", "pve", "server"],
    "ipaddr" = "10.69.69.1"
  },
  # "nas1" = {
  #   "groups" = ["baremetal", "unraid", "nas", "server"],
  #   "ipaddr" = "10.69.69.2"
  # }
}
