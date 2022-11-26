resource "aws_vpc" "sample-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    "Name" = "sample-vpc"
  }
  tags_all = {
    "Name" = "sample-vpc"
  }
}

resource "aws_subnet" "sample-subnet-public1-ap-northeast-1a" {
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.0.0.0/20"
  vpc_id = aws_vpc.sample-vpc.id
  tags = {
    "Name" = "sample-subnet-public1-ap-northeast-1a"
  }
  tags_all = {
    "Name" = "sample-subnet-public1-ap-northeast-1a"
  }
}

resource "aws_subnet" "sample-subnet-private1-ap-northeast-1a" {
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.0.128.0/20"
  vpc_id = aws_vpc.sample-vpc.id
  tags = {
    "Name" = "sample-subnet-private1-ap-northeast-1a"
  }
  tags_all = {
    "Name" = "sample-subnet-private1-ap-northeast-1a"
  }  
}

resource "aws_subnet" "sample-subnet-public1-ap-northeast-1c" {
  availability_zone = "ap-northeast-1c"
  cidr_block = "10.0.16.0/20"
  vpc_id = aws_vpc.sample-vpc.id
  tags = {
    "Name" = "sample-subnet-public1-ap-northeast-1c"
  }
  tags_all = {
    "Name" = "sample-subnet-public1-ap-northeast-1c"
  }
}

resource "aws_subnet" "sample-subnet-private1-ap-northeast-1c" {
  availability_zone = "ap-northeast-1c"
  cidr_block = "10.0.80.0/20"
  vpc_id = aws_vpc.sample-vpc.id
  tags = {
    "Name" = "sample-subnet-private1-ap-northeast-1c"
  }
  tags_all = {
    "Name" = "sample-subnet-private1-ap-northeast-1c"
  }    
}

resource "aws_internet_gateway" "sample-igw" {
  vpc_id = aws_vpc.sample-vpc.id
  tags = {
    "Name" = "sample-igw"
  }
  tags_all = {
    "Name" = "sample-igw"
  }
}

resource "aws_route_table" "sample-rtb-public" {
  vpc_id = aws_vpc.sample-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sample-igw.id
  }
  tags = {
    "Name" = "sample-rtb-public"
  }
  tags_all = {
    "Name" = "sample-rtb-public"
  }
}

resource "aws_route_table" "sample-rtb-private1-ap-northeast-1a" {
  vpc_id = aws_vpc.sample-vpc.id
  route = []
  tags = {
    "Name" = "sample-rtb-private1-ap-northeast-1a"
  }
  tags_all = {
    "Name" = "sample-rtb-private1-ap-northeast-1a"
  }
}

resource "aws_route_table" "sample-rtb-private1-ap-northeast-1c" {
  vpc_id = aws_vpc.sample-vpc.id
  route = []
  tags = {
    "Name" = "sample-rtb-private1-ap-northeast-1c"
  }
  tags_all = {
    "Name" = "sample-rtb-private1-ap-northeast-1c"
  }
}

resource "aws_vpc_endpoint" "sample-vpce-s3" {
  vpc_id = aws_vpc.sample-vpc.id
  service_name = "com.amazonaws.ap-northeast-1.s3"
  tags = {
    "Name" = "sample-vpce-s3"
  }
  tags_all = {
    "Name" = "sample-vpce-s3"
  }
}

resource "aws_eip" "nat-gateway-ip" {

}

resource "aws_eip" "nat-gateway-02-ip" {

}

resource "aws_nat_gateway" "sample-nat-gateway" {
  allocation_id = aws_eip.nat-gateway-ip.allocation_id
  subnet_id = aws_subnet.sample-subnet-public1-ap-northeast-1a.id
  tags = {
    "Name" = "sample-nat-gateway"
  }
  tags_all = {
    "Name" = "sample-nat-gateway"
  }
}

resource "aws_nat_gateway" "sample-nat-gateway-02" {
  allocation_id = aws_eip.nat-gateway-02-ip.allocation_id
  subnet_id = aws_subnet.sample-subnet-public1-ap-northeast-1c.id
  tags = {
    "Name" = "sample-nat-gateway-02"
  }
  tags_all = {
    "Name" = "sample-nat-gateway-02"
  }
}

resource "aws_security_group" "sample-sg-bastion" {
  name = "sample-sg-bastion"
  description = "for bastion"
  vpc_id = aws_vpc.sample-vpc.id
  ingress = [
    {
      description = ""
      protocol = "tcp"
      from_port = 22
      to_port = 22
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups  = []
      self = false
    }
  ]
}

resource "aws_security_group" "sample-sg-elb" {
  name = "sample-sg-elb"
  description = "for load balancer"
  vpc_id = aws_vpc.sample-vpc.id
  ingress = [
    {
      description = ""
      protocol = "tcp"
      from_port = 443
      to_port = 443
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups  = []
      self = false
    },
    {
      description = ""
      protocol = "tcp"
      from_port = 80
      to_port = 80
      cidr_blocks = [
        "0.0.0.0/0",
      ]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups  = []
      self = false
    }
  ]
}