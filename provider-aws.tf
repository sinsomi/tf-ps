#aws_key_pair, aws_security_group, aws_instance, aws_db_instance
# 접속하기 위해서 IAM KEY를 생성하여 등록을 해야 접속이 가능

provider "aws" {
  access_key = "AKIA4YH663E5SYW47XVG"
  secret_key = "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"
  region     = "ap-southeast-1"
  #region     = "us-east-1"
}

resource "aws_key_pair" "terraform_admin" {
  key_name = "terraform_admin"
  #public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJ32+nbweRPOnORwCEWKSjxhFeYwgBmPLaSEZzFOep4WWEr6V1K7OLTKON5rT6V95D7j8flFNuqrPZw5IjsmmJXk6TC5x/ZddEDyCJLKKAdkadcZQT9Bp5/B5bLyWW9O4hmjwUFqWkOznEcmcm44x1KqGpXBohEib8RFZDcdF3ojHRGoyJd4DBzq2WWSK2UQoXsiGcOvJfRtnEBiMJvSvJreEsn+ZzwjnNbxS9xXV4m6+ihWqqiouAOjvq3TWqT5SRMpaMRM2EES0SCjErBKGpxpBcjjud+2K20uB32VKpc03MqjbDI7HtJJjOotZekwFCB2kJ3gxC+0LSuvMPvamDUdJrufewwn1vJk6q3CSo1P9LnGTti/Bd/HTWH6z1L7YVIV8ARhofIDevMySGKuAG/asoUGZ1WIM9XKtgI+ctw4ycfoCAd01wDS6jprSiMAnPjBEH0HLT0fe3dWgJ70WV4cmoCQ/KJ4N8utjnhZgog+3xIfRm5hPT5OKCk/X2UH0hBp00z8C7kTWqj0ZlRkt5KncWhkxP5ngmxiDKiBBHDg9xm1wAwtKCfXRiF54/i7dHSroknEzngV/7Yujx1nRVl9SLAauflDL9YdU9rj2jQROxP2NcJeb9dGhSu3ik5yCwX+cBKDlUdXTpvdQeWEe6oy5tpXSw1jX63G2aIxXOkQ== cloud_ps@tmax.co.kr"
  public_key = file("../.ssh/web_admin.pub")
}
