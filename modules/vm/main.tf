terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.82.1"
    }
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  name      = var.name
  node_name = var.node_name
  vm_id     = var.vm_id
   # Conforme discutimos anteriormente

  clone {
    vm_id = var.base_template_id
    full  = true
  }

  cpu {
    cores = var.cpu_cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory_mb
  }

  disk {
    datastore_id = var.disk_datastore
    interface    = "scsi0"
    size         = var.disk_size
  }

  network_device {
    bridge = var.network_bridge
  }

  initialization {
    datastore_id = var.cloudinit_datastore
    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.network_gateway
      }
    }
    user_account {
      username = var.username
      keys     = [file(var.ssh_public_key)]
    }
  }  
}