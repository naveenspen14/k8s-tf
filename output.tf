


output "lbhost_publicip" {
value = module.k8s_haproxy.lbhost_publicip
}

output "worker_publicip" {
value = module.k8s_worker.worker_publicip
}

output "master_publicip" {
value = module.k8s_master.master_publicip
}

output "join_command" {
  value       = module.k8s_master.join_command
  description = "Join command to be executed at Worker server"
}

