variable "name" {
  type = string
}

variable "node_name" {
  type = string
}

variable "vm_id" {
  type = number
}

variable "base_template_id" {
  type = number
}

variable "cpu_cores" {
  type = number
}

variable "cpu_type" {
  type = string
}

variable "memory_mb" {
  type = number
}

variable "disk_size" {
  type = number
}

variable "disk_datastore" {
  type = string
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "cloudinit_datastore" {
  type = string
}

variable "ipv4_address" {
  type    = string
}

variable "username" {
  type = string
}

variable "ssh_public_key" {
  type = string
  description = "Path to the SSH public key file."
}

variable "ssh_private_key" {
  type = string
}

variable "network_gateway" {
  type = string
}