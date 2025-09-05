[all]
%{ for vm in masters ~}
${vm.name} ansible_host=${split("/", vm.initialization[0].ip_config[0].ipv4[0].address)[0]} ip=${split("/", vm.initialization[0].ip_config[0].ipv4[0].address)[0]}
%{ endfor ~}
%{ for vm in workers ~}
${vm.name} ansible_host=${split("/", vm.initialization[0].ip_config[0].ipv4[0].address)[0]} ip=${split("/", vm.initialization[0].ip_config[0].ipv4[0].address)[0]}
%{ endfor ~}

[kube_control_plane]
%{ for vm in masters ~}
${vm.name}
%{ endfor ~}

[etcd]
%{ for vm in masters ~}
${vm.name}
%{ endfor ~}

[kube_node]
%{ for vm in workers ~}
${vm.name}
%{ endfor ~}

[k8s_cluster:children]
kube_control_plane
kube_node