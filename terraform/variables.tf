variable "public_key" {
  default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMD7LXEdkg8CBIX03erzWVe5EYt88EQtEWIIiwz1HjLl terraform"
}

variable "ssh_username" {
  default = "student"
}

variable "memory_mb" {
  default = 1024
}

variable "num_cpus" {
  default = 1
}

variable "disk_store" {
  default = "datastore1"
}

variable "ovf_source" {
  default = "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.ova"
}

variable "network" {
  default = "VM Network"
}
