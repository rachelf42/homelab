resource "proxmox_virtual_environment_download_file" "template-lxc-ubuntu-noble" {
  content_type = "vztmpl"
  datastore_id = "local"
  node_name    = var.proxmox_default_node
  url          = "http://download.proxmox.com/images/system/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
}
data "proxmox_virtual_environment_vm" "template-vm-ubuntu-noble" {
  node_name = var.proxmox_default_node
  vm_id     = var.proxmox_packer_vmid
}
