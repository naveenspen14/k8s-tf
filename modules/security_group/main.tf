# aws_security_group.aws_master_sg.id

variable "ingress_ports_master" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [22, 80, 6443, 443, 9099, 179]
}

variable "ingress_ports_worker" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [22, 80, 443, 9099, 179, 9000]
}

resource "aws_security_group" "aws_master_sg" {
  #name = var.master_sg_name
  name = var.aws_master_sg
  description = "aws_master_sg"
  vpc_id = var.vpc_id 

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  dynamic "ingress" {
      iterator = port
      for_each = var.ingress_ports_master
      content {
        from_port   = port.value
        to_port     = port.value
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
  }

  tags = {
    "Name" = "aws_master_sg"
  }
}

resource "aws_security_group" "aws_worker_sg" {
  #name = var.worker_sg_name
  name = var.aws_worker_sg
  description = "aws_worker_sg"
  #vpc_id = aws_vpc.main_vpc.id
  #vpc_id = module.vpc.main_vpc.id
  vpc_id = var.vpc_id

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  dynamic "ingress" {
      iterator = port
      for_each = var.ingress_ports_worker
      content {
        from_port   = port.value
        to_port     = port.value
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }

  }

  tags = {
    "Name" = "aws_worker_sg"
  }
}
