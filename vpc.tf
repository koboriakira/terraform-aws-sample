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
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone = "ap-northeast-1a"
  
}

resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = aws_vpc.sample-vpc.id
  
}