resource "aws_lb" "sample-alb" {
  name = "sample-alb"
  load_balancer_type = "application"
  internal = false
  idle_timeout = 60
  enable_deletion_protection = false # 設定を誤って消さないようにする

  subnets = [ aws_subnet.public-0.id, aws_subnet.public-1.id ]
  
  # access_logs {} TODO: あとで

  security_groups = [ 
    module.http-sg.security_group_id,
    # module.https-sg.security_group_id,
    # module.http-redirect-sg.security_group_id,
  ]
  
}

output "alb_dns_name" {
  value = aws_lb.sample-alb.dns_name
}