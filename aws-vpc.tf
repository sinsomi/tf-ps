
# VPC and
variable "vpc_cidr_info" {
  description = "VPC cidr BLOCK : x.x.x.x/x"
  default = "10.10.0.0/16"
}
variable "subnet_cidr_info" {
  description = "VPC SUBNET cidr BLOCK : x.x.x.x/x"
  default = "10.10.10.0/24"
}

resource "aws_vpc" "vpc" {
  cidr_block  = var.vpc_cidr_info
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"

  tags = {
    Name = "private vpc"
  }
}

resource "aws_subnet" "subnet_public_zone" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.subnet_cidr_info
  map_public_ip_on_launch = true
  #  all_availability_zones= true
  availability_zone = "ap-southeast-1a"

  #   availability_zones = data.aws_availability_zones.all.names

  tags = {
    Name = "Public Zone subnet "
    Group = "G-Master"
  }
}