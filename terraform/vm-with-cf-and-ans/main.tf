terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}
data "proxmox_virtual_environment_vm" "template-vm-ubuntu-noble" {
  node_name = var.proxmox_default_node # TODO: can we deduplicate this
                                       # Issue URL: https://github.com/rachelf42/homelab/issues/27
  vm_id     = var.proxmox_packer_vmid
}
module "cf_and_ans" {
  source = "../cloudflare-and-ansible-host"
  name   = var.name
  groups = setunion([
    "server",
    "vm",
    "ubuntu"
  ], var.additional_groups)
  ipaddr       = var.ipaddr
  cf_domain    = var.cf_domain
  cf_zone_id   = var.cf_zone_id
  user_name    = "rachel"
  ansible_user = "ansible"
}
resource "proxmox_virtual_environment_vm" "vm" {
  name          = var.name
  node_name     = var.proxmox_default_node
  description   = "MANAGED BY TERRAFORM"
  tags          = setunion(["terraform"], var.additional_tags)
  timeout_clone = 7200
  scsi_hardware = "virtio-scsi-single"
  boot_order    = ["scsi0", "net0"]
  clone {
    vm_id = var.proxmox_packer_vmid
  }
  lifecycle {
    precondition {
      condition     = data.proxmox_virtual_environment_vm.template-vm-ubuntu-noble.template == true && contains(data.proxmox_virtual_environment_vm.template-vm-ubuntu-noble.tags, "packer-template")
      error_message = "Packer Template Missing!"
    }
  }
  agent {
    enabled = true
  }
  initialization {
    dns {
      domain  = "local.rachelf42.ca"
      servers = [var.dns1, var.dns2]
    }
    ip_config {
      ipv4 {
        address = "${var.ipaddr}/${var.cidr}"
        gateway = var.gateway
      }
    }
    user_account {
      username = "rachel"
      password = var.secure_password
    }
  }
  cpu {
    cores   = var.cores
    sockets = 1
    type    = "x86-64-v2-AES"
  }
  memory {
    dedicated = var.memory
    floating  = var.memfloat != null ? var.memfloat : var.memory
  }
  network_device {
    bridge       = "vmbr0"
    disconnected = false
    enabled      = true
    firewall     = true
    model        = "virtio"
  }
  startup {
    down_delay = 300
    order      = 0
    up_delay   = 300
  }
}