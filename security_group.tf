module "sample-sg" {
  source = "./security_group"
  name = "sample-sg"
  vpc_id = aws_vpc.sample-vpc.id
  port = 80
  cidr_blocks = ["0.0.0.0/0"]

}