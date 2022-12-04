data "aws_caller_identity" "current" {}

data "aws_canonical_user_id" "current" {}

data "aws_cloudtrail_service_account" "current" {}

resource "aws_s3_bucket" "cloudtrail_s3" {
  bucket = "koboriakira-cloudtrail-s3"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.cloudtrail_s3.id
  versioning_configuration {
    status = "Disabled"
  }
}

# resource "aws_s3_bucket_acl" "cloudtrail_s3_acl" {
#   bucket = aws_s3_bucket.cloudtrail_s3.id

#   access_control_policy {
#     grant {
#       grantee {
#         id   = data.aws_canonical_user_id.current.id
#         type = "CanonicalUser"
#       }
#       permission = "FULL_CONTROL"
#     }

#     owner {
#       id = data.aws_canonical_user_id.current.id
#     }
#   }
# }

resource "aws_s3_bucket_policy" "cloudtrail_s3" {
  bucket = aws_s3_bucket.cloudtrail_s3.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.cloudtrail_s3.arn}"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.cloudtrail_s3.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

resource "aws_cloudtrail" "management-events" {
  name = "management-events"
  s3_bucket_name = aws_s3_bucket.cloudtrail_s3.id
  enable_logging = true
  include_global_service_events = true
  is_multi_region_trail = false
  is_organization_trail = false
}


output "aws_canonical_user_id_current_id" {
  value = data.aws_canonical_user_id.current.id
}

output "aws_caller_identity_current_account_id" {
  value = data.aws_caller_identity.current.account_id
}
