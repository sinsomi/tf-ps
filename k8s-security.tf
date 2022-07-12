# Management
resource "aws_security_group" "sg_default" {
  name = "sg_default"
  #  id = "sg-030cbf7c01bfb9b00"
  vpc_id = aws_vpc.vpc.id
  description = "Allow SSH port from all"
  tags = {
    name = "allow"
  }
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_default.id
  lifecycle { create_before_destroy = true }
}
resource "aws_security_group_rule" "icmp" {
  type              = "ingress"
  from_port         = 8
  to_port           = 0
  protocol          = "ICMP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_default.id
  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_default.id
  lifecycle { create_before_destroy = true }
}


#K8S Cluster Open
resource "aws_security_group" "sg-cluster" {
  name = "sg_cluster-default"
  vpc_id = aws_vpc.vpc.id
  description = "All Port Open from Cluster zone"
  tags = {
    name = "allow"
  }
}
# subnet 간 통신 허용
resource "aws_security_group_rule" "cluster-all" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["10.10.0.0/16"]
  security_group_id = aws_security_group.sg-cluster.id
  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "cluster-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg-cluster.id
  lifecycle { create_before_destroy = true }
}

# keycloak ui
resource "aws_security_group" "sg-front" {
  name = "sg_frontweb"
  vpc_id = aws_vpc.vpc.id
  description = "All Port Open from Cluster zone"
  tags = {
    name = "allow"
  }
}
resource "aws_security_group_rule" "front-ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg-front.id
  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "front-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg-front.id
  lifecycle { create_before_destroy = true }
}

# NFS Storage
resource "aws_security_group" "sg-nfs" {
  name = "sg_nfs"
  vpc_id = aws_vpc.vpc.id
  description = "All Port Open from Cluster zone"
  tags = {
    name = "allow"
  }
}
resource "aws_security_group_rule" "nfs-ingress" {
  type              = "ingress"
  from_port         = 0 #2049
  to_port           = 0 #2049
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg-nfs.id
  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "nfs-egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg-nfs.id
  lifecycle { create_before_destroy = true }
}