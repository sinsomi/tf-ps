#aws_key_pair, aws_security_group, aws_instance, aws_db_instance
# 접속하기 위해서 IAM KEY를 생성하여 등록을 해야 접속이 가능

provider "aws" {
  access_key = "AKIAVVIWUDOGQMPYRDMQ"
  secret_key = "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"
  region     = "eu-west-1"
}

resource "aws_key_pair" "test" {
  key_name = "test"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDwqAbfXPpkwtLoO5zFmXgPWGdyEqIhFLLnXbgnrWRQzFCjq2Ic2rVpPorAk4YcbI0iqMLN5G/vVViMt5UVQlxfQrUmKUD5CfYL+kyVcfnIQzBtX4XJZjPPubs0OaiIq3MYg3GpNXHxdfB0y4fupIjGeE/LQElxtyU5UYwAd60TdkjlyDFuu2LdL5aqV+BzK4So/PF4SoBgrAQhVdWUKqOmqhR+YIRKcuOV3Q4RKUkTFO8GivYcZnWWurvD/vXZ5xtBMTup3DObhU+VDKP2dBSgqdVF24FAVXHlR302Ld2Db64BsiYvVRBRXbkHRAaZw7EvALBkmMuGWm/VLolMoRRzm2ulgdn4esUYB1dY/Ahgmm6k7OL8Gky+KPs8xpImu2qZorZJBCl+g++JJ7tV4x+3gKm3J9oK2PN1l+gUhA2GjKkOyMcXR5VK426NA++CAERSKjn1lXGo7H19HvXf7vTbtDwpkPqyTzPhNMgNQTtq6Qh8jMQ04lE524yfSl7rxLs= hc@hc5-master1"
}
