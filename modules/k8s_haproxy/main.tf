
####### LB host
resource "aws_instance" "lb_host" {
  count = var.lb_count
  instance_type = var.instance_type
  ami = var.ami-id 
  #subnet_id = aws_subnet.public_subnet.id
  subnet_id = var.public_subnet
  vpc_security_group_ids = var.vpc_security_group_ids
  iam_instance_profile = var.iam_worker_role
  key_name = var.aws_keyname

  lifecycle {
    create_before_destroy = true
  } 

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 20
    delete_on_termination = true
  } 
  ebs_optimized = false
  tags = {
    "Name" = "LBHost"
    "Description" = "HA Proxy Host"
    "Owner" = "AIRASIA"
    "kubernetes.io/cluster/${var.outposts_cluster_name}" = "owned"
  }
}

