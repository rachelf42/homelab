# COMMON VARS
proxmox_default_node = "pve-laptop"
proxmox_api_token_id = "root@pam!cicd"
proxmox_api_url      = "https://10.69.69.1:8006/api2/json"
# PACKER VARS
proxmox_storage     = "local-lvm"
proxmox_iso_storage = "local"
# TERRAFORM VARS
dns1 = "1.1.1.1"
dns2 = "1.0.0.1"
# WARNING: run ../ansible/playbooks/bootstrap.yaml before adding a node here
pve-nodes = [
  "pve-laptop"
]