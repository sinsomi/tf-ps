#aws_key_pair, aws_security_group, aws_instance, aws_db_instance
# 접속하기 위해서 IAM KEY를 생성하여 등록을 해야 접속이 가능

provider "aws" {
  access_key = "AKIAVVIWUDOGQMPYRDMQ"
  secret_key = "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"
  region     = "eu-west-1"
}

resource "aws_key_pair" "terraform_admin" {
  key_name = "terraform_admin"
  public_key = file("../.ssh/web_admin.pub")
}
