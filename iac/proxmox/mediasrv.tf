# vim: set tabstop=2
# vim: filetype=json
resource "proxmox_virtual_environment_vm" "mediasrv" {
  name          = "mediasrv"
  node_name     = var.proxmox_default_node
  description   = "MANAGED BY TERRAFORM"
  tags          = ["terraform"]
  scsi_hardware = "virtio-scsi-single"
  boot_order    = ["scsi0", "net0"]
  clone {
    vm_id = var.proxmox_packer_vmid
  }
  lifecycle {
    precondition {
      condition     = data.proxmox_virtual_environment_vm.ubuntu-noble-template.template == true && contains(data.proxmox_virtual_environment_vm.ubuntu-noble-template.tags, "packer-template")
      error_message = "Packer Template Missing!"
    }
  }
  agent {
    enabled = true
  }
  initialization {
    dns {
      domain  = "local.rachelf42.ca"
      servers = ["9.9.9.9", "149.112.112.112"]
    }
    ip_config {
      ipv4 {
        address = "10.69.69.69/8"
        gateway = "10.0.0.1"
      }
    }
    user_account {
      username = "rachel"
      password = ""
      keys = []
    }
  }
  cpu {
    cores   = 1
    sockets = 1
    type    = "x86-64-v2-AES"
  }
  memory {
    dedicated = 2048
    floating  = 1024
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
    order      = 1
    up_delay   = 300
  }
}
