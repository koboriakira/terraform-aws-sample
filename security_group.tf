module "http-sg" {
  source = "./security_group"
  name = "http-sg"
  vpc_id = aws_vpc.sample-vpc.id
  port = 80
  cidr_blocks = ["0.0.0.0/0"]

}