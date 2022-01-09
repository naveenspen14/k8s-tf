
# VPC creation
resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

   tags = {
      Name = "airasia_auotmation_VPC"
  }
}

# Internet Gateway creation
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "internet_gateway"
  }
}

# Internet gateway route creation
resource "aws_route" "internet_gw_route" {
  route_table_id            = aws_vpc.main_vpc.default_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id =  aws_internet_gateway.internet_gateway.id
}

