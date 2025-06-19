ansible_statics = {
  "rachel-pc" = {
    "ansible_keyfile" = "~/.ssh/id_ed25519",
    "groups"          = ["baremetal", "ubuntu", "devmachine"],
    "ipaddr"          = "10.69.1.69"
  },
  "pve-laptop" = {
    "ansible_user" = "root",
    "groups"       = ["baremetal", "debian", "pve", "server"],
    "ipaddr"       = "10.69.69.1"
  },
  "storinator" = {
    "groups" = ["baremetal", "truenas", "nas", "server"],
    "ipaddr" = "10.69.69.96"
  }
}
