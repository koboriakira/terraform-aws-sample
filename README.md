# terraform-aws-sample

Terraformを使ったAWS環境構築のサンプル。

## 実行方法

`terraform`コマンドで実施。
[hashicorp/terraform - Docker Image | Docker Hub](https://hub.docker.com/r/hashicorp/terraform/)でDockerイメージが提供されているので、次のようにしてどのような環境でも実行できるようにしておく。

```shell
function terraform_function() {
  if [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$AWS_SECRET_ACCESS_KEY" ] && [ -n "$AWS_DEFAULT_REGION" ]; then
    docker run --platform linux/amd64 -it --rm -v $PWD:/work -w /work -e "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" -e "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" -e "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" hashicorp/terraform:latest ${@:1}
  else
    echo "AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGIONのいずれかが未設定"
  fi
}
```

## よくある使い方

### `terraform state show {リソース名｝`

すでに作成されているAWSリソースをterraformの書き方だとどうなるか表示する。
コマンド実施前にリソース名をtfファイルに書いておくこと

### `terraform plan`

いわゆるdry-run

### `terraform apply`

`terraform apply -target={リソース名}`で、該当のリソースだけ適用することができる。

### `terraform destroy`

破棄。有償のリソースもあるので、テストが終わったら、すぐに消しておくこと。
これも`apply`同様に`-target={リソース名}`で指定可能。