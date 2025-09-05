

disk_datastore      = "vms2"
cloudinit_datastore = "vms2"




masters = {
  "manager1-k8s" = { vm_id=207, cpu_cores=2, cpu_type="host", memory_mb=4096, disk_size=50, ipv4_address="192.168.18.207/24" }
  #"manager2-k8s" = { vm_id=212, cpu_cores=2, cpu_type="host", memory_mb=4096, disk_size=50, ipv4_address="192.168.18.212/24" }
  #"manager3-k8s" = { vm_id=213, cpu_cores=2, cpu_type="host", memory_mb=4096, disk_size=50, ipv4_address="192.168.18.213/24" }
}

workers = {
  "worker1-k8s"  = { vm_id=208, cpu_cores=1, cpu_type="host", memory_mb=2048, disk_size=25, ipv4_address="192.168.18.208/24" }
  #"worker2-k8s"  = { vm_id=222, cpu_cores=1, cpu_type="host", memory_mb=2048, disk_size=25, ipv4_address="192.168.18.222/24" }
  #"worker3-k8s"  = { vm_id=223, cpu_cores=1, cpu_type="host", memory_mb=2048, disk_size=25, ipv4_address="192.168.18.223/24" }
}