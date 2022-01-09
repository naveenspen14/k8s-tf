
output "worker_publicip" {
value = aws_instance.workerhost.*.public_ip
}
