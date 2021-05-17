provider "aws" {
  region = "ap-south-1"
  #Using static credentials for the creation of resources in AWS
  access_key = ""
  secret_key = ""
}

#To fetch the list of availability_zone in the ap-south-1, data which we are fetching in read only mode.
data "aws_availability_zones" "available" {}

# VPC Creation

resource "aws_vpc" "elasticsearch_vpc" {
  #to define the ip range by user.
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "elasticsearch-vpc"
  }
}

# Creating Internet Gateway in case servers need to launched in public subnet.

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "elasticsearch-igw"
  }
}

#NAT gateway for private route table and private subnet
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.private_subnet

  tags = {
    Name = "elasticsearch-NAT"
  }
}

# Public Route Table

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "elasticsearch-public-route-table"
  }
}

# Private Route Table using default route table as it's routing destination is local

resource "aws_default_route_table" "private_route" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    nat_gateway_id = aws_nat_gateway.gw.id
    cidr_block     = "0.0.0.0/0"
  }

  tags = {
    Name = "elasticsearch-private-route-table"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  count      = 2
  cidr_block = var.public_cidrs[count.index]
  vpc_id     = aws_vpc.main.id
  #auto-assign public ip from this public subnet and flag is set true
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "my-test-public-subnet.${count.index + 1}"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  count             = 2
  cidr_block        = var.private_cidrs[count.index]
  vpc_id            = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "my-test-private-subnet.${count.index + 1}"
  }
}

# Associating Public Subnet with Public Route Table
resource "aws_route_table_association" "public_subnet_assoc" {
  count          = 2
  route_table_id = aws_route_table.public_route.id
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  depends_on     = ["aws_route_table.public_route", "aws_subnet.public_subnet"]
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_subnet_assoc" {
  count          = 2
  route_table_id = aws_default_route_table.private_route.id
  subnet_id      = aws_subnet.private_subnet.*.id[count.index]
  depends_on     = ["aws_default_route_table.private_route", "aws_subnet.private_subnet"]
}

# Security Group Creation
resource "aws_security_group" "elasticsearch_sg" {
  name   = "elasticsearch-sg"
  vpc_id = aws_vpc.main.id
}

# Ingress Security Port 22
resource "aws_security_group_rule" "ssh_inbound_access" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.test_sg.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http_inbound_access" {
  from_port         = 9200
  protocol          = "tcp"
  security_group_id = aws_security_group.test_sg.id
  to_port           = 9300
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

# All OutBound Access
resource "aws_security_group_rule" "all_outbound_access" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.test_sg.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}
