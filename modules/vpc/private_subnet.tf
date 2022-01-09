

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.private_subnet_cidr_block
  availability_zone = var.public_subnet_zone
  outpost_arn = "arn:aws:outposts:us-west-2:475907706976:outpost/op-07a2766e46bb2d0b6"
  
  # following are anyway false by default, calling it explicit
  map_public_ip_on_launch = false 
  tags = {
    Name = "private_subnet"
  }
}

resource "aws_route_table" "private_route_table" {
  
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = var.private_route_table_cidr
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private_route_table"
  }
}

resource "aws_route_table_association" "private_rt_subnet" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}


