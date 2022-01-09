output "master_publicip" {
value = aws_instance.masterhost.*.public_ip
}

output "join_command" {
  value       = data.external.join_cmd.result.cmd
  description = "Join command to be executed at Worker server"
}

#output "outpost_kubeconfig" {
#  value = aws_instance.masterhost.*.kube_config
#}
