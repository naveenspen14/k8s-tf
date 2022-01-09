# aws_security_group.aws_master_sg.id

output "master_security_id" {
  value = aws_security_group.aws_master_sg.id
}

output "worker_security_id" {
  value = aws_security_group.aws_worker_sg.id
}

