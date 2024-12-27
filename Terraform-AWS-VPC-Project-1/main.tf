# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "Vpc-Terra" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"

  tags = {
    Name = "Vpc-Terra"
  }
}

resource "aws_internet_gateway" "Igw-Terra" {
  vpc_id = aws_vpc.Vpc-Terra.id

  tags = {
    Name = "Igw-Terra"
  }
}

resource "aws_subnet" "Public-Subnet-Terra" {
  vpc_id     = aws_vpc.Vpc-Terra.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Public-Subnet-Terra"
  }
}

resource "aws_route_table" "Public-RT-Terra" {
  vpc_id = aws_vpc.Vpc-Terra.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Igw-Terra.id
  }

  tags = {
    Name = "Public-RT-Terra"
  }
}

resource "aws_route_table_association" "Public-RTA-Terra" {
  subnet_id      = aws_subnet.Public-Subnet-Terra.id
  route_table_id = aws_route_table.Public-RT-Terra.id
}

resource "aws_security_group" "allow-all" {
  name        = "allow-all"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.Vpc-Terra.id
  tags = {
    Name = "allow-all"
  }
}

resource "aws_vpc_security_group_ingress_rule" "Inbound-Terra" {
  security_group_id = aws_security_group.allow-all.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 0
}

resource "aws_vpc_security_group_egress_rule" "Outbound-Terra" {
  security_group_id = aws_security_group.allow-all.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 0
}
