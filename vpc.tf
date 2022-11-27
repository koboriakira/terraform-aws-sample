resource "aws_vpc" "sample-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "sample-vpc"
  }
  
}

resource "aws_subnet" "public-0" {
  vpc_id = aws_vpc.sample-vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1a"
  
}
resource "aws_subnet" "public-1" {
  vpc_id = aws_vpc.sample-vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1c"
  
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.sample-vpc.id
}

resource "aws_internet_gateway" "sample-igw" {
  vpc_id = aws_vpc.sample-vpc.id
  
}

resource "aws_route_table_association" "public-0" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public-0.id
}

resource "aws_route_table_association" "public-1" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public-1.id
}

resource "aws_subnet" "private-0" {
  vpc_id = aws_vpc.sample-vpc.id
  cidr_block = "10.0.65.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "private-1" {
  vpc_id = aws_vpc.sample-vpc.id
  cidr_block = "10.0.66.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-1c"
  
}

resource "aws_eip" "nat-gateway-0" {
  vpc = true
  depends_on = [aws_internet_gateway.sample-igw]
  
}

resource "aws_eip" "nat-gateway-1" {
  vpc = true
  depends_on = [aws_internet_gateway.sample-igw]
}

resource "aws_nat_gateway" "nat-gateway-0" {
  allocation_id = aws_eip.nat-gateway-0.id
  subnet_id = aws_subnet.public-0.id
  depends_on = [aws_internet_gateway.sample-igw]

}

resource "aws_nat_gateway" "nat-gateway-1" {
  allocation_id = aws_eip.nat-gateway-1.id
  subnet_id = aws_subnet.public-1.id
  depends_on = [aws_internet_gateway.sample-igw]
  
}

resource "aws_route_table" "private-0" {
  vpc_id = aws_vpc.sample-vpc.id
}

resource "aws_route_table" "private-1" {
  vpc_id = aws_vpc.sample-vpc.id
}

resource "aws_route" "private-0" {
  route_table_id = aws_route_table.private-0.id
  nat_gateway_id = aws_nat_gateway.nat-gateway-0.id
  destination_cidr_block = "0.0.0.0/0"

}

resource "aws_route" "private-1" {
  route_table_id = aws_route_table.private-1.id
  nat_gateway_id = aws_nat_gateway.nat-gateway-1.id
  destination_cidr_block = "0.0.0.0/0"

}

resource "aws_route_table_association" "private-0" {
  route_table_id = aws_route_table.private-0.id
  subnet_id = aws_subnet.private-0.id
}

resource "aws_route_table_association" "private-1" {
  route_table_id = aws_route_table.private-1.id
  subnet_id = aws_subnet.private-1.id
}