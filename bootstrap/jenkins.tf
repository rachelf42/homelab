resource "proxmox_virtual_environment_vm" "vm" {
  name          = "jenkins"
  node_name     = "pve-laptop"
  description   = "MANAGED BY TERRAFORM"
  tags          = ["terraform","jenkins"]
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
        address = "10.69.69.254/8"
        gateway = "10.0.0.1"
      }
    }
    user_account {
      username = "rachel"
      password = var.secure_password
    }
  }
  cpu {
    cores   = 2
    sockets = 1
    type    = "x86-64-v2-AES"
  }
  memory {
    dedicated = 2048
    floating  = 2048
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