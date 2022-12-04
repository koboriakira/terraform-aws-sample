# CloudTrail

S3バケットを作成して、そのバケットに記録するCloudTrailを構築する。

エラーが起きて実際に構築まではできなかった。S3がらみのエラーが解消できず。

## リソース

- `aws_s3_bucket` ([refs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket))
  - 詳細な設定は、後述のリソースで設定する
- `aws_s3_bucket_acl` ([refs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl))
  - S3のアクセスコントロールポリシーの設定
  - `terraform destroy`でstateは消えるが、AWS上は消えないらしい
- `aws_s3_bucket_policy` ([refs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy))
  - バケットポリシー
  - 今回はCloudTrailサービスがバケットのACL取得とファイル追加をしてもよいようにする
- `aws_cloudtrail` ([refs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudtrail))
  - `s3_bucket_name`を設定すれば、あとはデフォルトでOK
  - 詳細設定したい場合は


## データソース

- `aws_cloudtrail_service_account` [refs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudtrail_service_account)
  - CloudTrailのアカウントID
- `aws_canonical_user_id` ([refs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id))
  - 正規ユーザIDと呼ばれ、AWSアカウントIDを難読化した形式らしい
    - [Viewing account identifiers - AWS Account Management](https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-identifiers.html)
- `aws_caller_identity`
  - AWSアカウントID（一意に識別する12桁の数値）を取得するときに利用できる

## エラー

### バケットACLの`grant.grantee`

`grant.grantee`で定義するIDは正規ユーザIDのみだったので、リソースではなくアイデンティティを指定しないといけない？

### `Error creating CloudTrail: InsufficientS3BucketPolicyException: Incorrect S3 bucket policy is detected for bucket: koboriakira-cloudtrail-s3`

よくわからず。