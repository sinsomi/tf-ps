terraform {
  required_version = "0.15.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0.0"
    }
  }

}

resource "aws_internet_gateway" "vpc_gw"  {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "vpc_gw"
  }
}
resource "aws_route" "side_effect_internet_access" {
  route_table_id = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.vpc_gw.id
}
# associate subnets to route tables
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id = aws_subnet.subnet_public_zone.id
  route_table_id = aws_vpc.vpc.main_route_table_id
}

# eip for NAT
resource "aws_eip" "vpc_nat_eip" {
  vpc = true
  depends_on = [aws_internet_gateway.vpc_gw]
}
# NAT gateway
resource "aws_nat_gateway" "private_nat" {
  allocation_id = aws_eip.vpc_nat_eip.id
  subnet_id = aws_subnet.subnet_public_zone.id
  depends_on = [aws_internet_gateway.vpc_gw]
}

resource "aws_instance" "private-registry" {
  ami = "ami-084be8fbdbd21b027"
  #cent8싱가폴
  instance_type = "t2.large" #"t2.micro"
  key_name = aws_key_pair.terraform_admin.key_name
  subnet_id = aws_subnet.subnet_public_zone.id
  count = 1
  private_ip = lookup(var.registry-ips, count.index)
  #
  associate_public_ip_address = true
  #Public IP 연결
  vpc_security_group_ids = [
    aws_security_group.sg-front.id,
    aws_security_group.sg-nfs.id
  ]
  user_data = data.template_cloudinit_config.registry-cloudinit.rendered
  tags = {
    Name = "G-registry"
  }
}

#output "a" {
#  value =var.node-list(values("private-registry"))
#  instance_ipaddress="${element(keys(var.node-list[count.index]), 0)}"
#  instance_hostname="${element(values(var.node-list[count.index]), 0)}"
#  all_host_info=replace(replace(jsonencode(var.node-list), "\"", ""), ":", "=")
#}

