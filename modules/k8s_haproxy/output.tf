
output "lbhost_publicip" {
value = aws_instance.lb_host.*.public_ip
}

