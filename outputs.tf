output "vm_names" {
  description = "Uma lista com os nomes de todas as VMs criadas (masters e workers)."
  value       = concat(
    [for vm in module.masters : vm.vm_details.name],
    [for vm in module.workers : vm.vm_details.name]
  )
}

output "vm_ips" {
  description = "Uma lista com os IPs de todas as VMs criadas."
  value       = concat(
    # Correção aqui
    [for vm in module.masters : vm.vm_details.ipv4_addresses[0]],
    # Correção aqui
    [for vm in module.workers : vm.vm_details.ipv4_addresses[0]]
  )
}