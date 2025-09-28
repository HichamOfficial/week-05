terraform {
  required_version = ">= 1.9.0"
  required_providers {
    esxi = {
      source  = "josenk/esxi"
      version = "1.10.3"
    }
  }
}

provider "esxi" {
  esxi_hostname = "192.168.1.60"   # jouw ESXi IP
  esxi_hostport = "22"
  esxi_hostssl  = "443"
  esxi_username = "root"
  esxi_password = "Welkom01!"
}

locals {
  templatevars = {
    public_key   = var.public_key
    ssh_username = var.ssh_username
  }
}

# Eenvoudige enkele VM
resource "esxi_guest" "demo_vm" {
  guest_name = "ci-demo-vm"
  disk_store = var.disk_store
  memsize    = var.memory_mb
  numvcpus   = var.num_cpus
  ovf_source = var.ovf_source

  network_interfaces {
    virtual_network = var.network
  }

  guestinfo = {
    "userdata"          = base64encode(templatefile("${path.module}/userdata.yaml", local.templatevars))
    "userdata.encoding" = "base64"
  }
}

# Output voor Ansible inventory
output "inventory" {
  value = <<EOT
[demo]
${esxi_guest.demo_vm.guest_name} ansible_host=${esxi_guest.demo_vm.ip_address} app_name=demoapp
EOT
}
