variable "proxmox_endpoint" {
  type        = string
  description = "API Endpoint Proxmox"
}

variable "proxmox_user" {
  type        = string
  description = "Proxmox User"
}

variable "proxmox_password" {
  type        = string
  description = "Proxmox Password"
  sensitive   = true
}

variable "node_name" {
  type        = string
  description = "Proxmox node name"
}

variable "base_template_id" {
  type        = number
  description = "The ID of the base Proxmox template that is configured with Cloud-Init."
}

variable "masters" {
  description = "Mapa de VMs para o Control Plane do Kubernetes"
  type = map(object({
    vm_id        = number
    cpu_cores    = number
    cpu_type     = string
    memory_mb    = number
    disk_size    = number
    ipv4_address = string
  }))
}

variable "workers" {
  description = "Mapa de VMs para os Worker Nodes do Kubernetes"
  type = map(object({
    vm_id        = number
    cpu_cores    = number
    cpu_type     = string
    memory_mb    = number
    disk_size    = number
    ipv4_address = string
  }))
}

variable "disk_datastore" {
  type        = string
  description = "The Proxmox datastore to use for VM disks."
}

variable "cloudinit_datastore" {
  type        = string
  description = "The Proxmox datastore to use for Cloud-Init images."
}

variable "node_address" {
  type        = string
  description = "The IP address of the Proxmox node for SSH connections."
}

variable "ssh_public_key" {
  type = string
}

variable "ssh_private_key" {
  type = string
}

variable "network_gateway" {
  type        = string
  description = "O endereço IP do gateway da rede (seu roteador)."
}