
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.public_subnet_zone
  outpost_arn = "arn:aws:outposts:us-west-2:475907706976:outpost/op-07a2766e46bb2d0b6"
  
  # following are anyway false by default, can make FALSE if EIP is planned
  map_public_ip_on_launch = true 
  
  # This customer_owned_ip configuration will come during field deployments, for now comment it 
  # map_customer_owned_ip_on_launch = false
  # customer_owned_ipv4_pool = # take it as input parameter
  
  #local_gateway_id
  tags = {
    Name = "airasia_auotmation_public_subnet"
  }
}

resource "aws_eip" "nat_gw_ip" {
  vpc      = true
  depends_on = [aws_internet_gateway.internet_gateway]
}

resource "aws_nat_gateway" "nat_gw" {

  allocation_id = aws_eip.nat_gw_ip.id 
  subnet_id     = aws_subnet.public_subnet.id

    #connectivity_type = "public"
  tags = {
    Name = "nat_gw"
  }

  depends_on = [aws_eip.nat_gw_ip]
}

