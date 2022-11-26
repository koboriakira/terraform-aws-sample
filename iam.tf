resource "aws_iam_role" "role-sample-web" {
  name                  = "role-sample-web"
  description           = "role-sample-web"
  assume_role_policy    = jsonencode(
        {
            Statement = [
                {
                    Action    = "sts:AssumeRole"
                    Effect    = "Allow"
                    Principal = {
                        Service = "ec2.amazonaws.com"
                    }
                },
            ]
            Version   = "2012-10-17"
        }
    )
}