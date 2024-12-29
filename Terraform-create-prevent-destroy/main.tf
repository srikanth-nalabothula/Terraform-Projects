# Configure the AWS Provider
provider "aws" {
  region = var.region_name
}

resource "aws_vpc" "Vpc-Terra" {
  cidr_block           = var.vpc-cidr_block
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name    = var.vpc_tag
    Service = "Terraform"
  }
}

resource "aws_internet_gateway" "Igw-Terra" {
  vpc_id = aws_vpc.Vpc-Terra.id

  tags = {
    Name    = var.igw_tag
    Service = "Terraform"
  }
}

resource "aws_subnet" "Public-Subnet-Terra" {
  vpc_id                  = aws_vpc.Vpc-Terra.id
  cidr_block              = var.subnet-cidr_block
  map_public_ip_on_launch = true
  availability_zone       = var.subnet_az

  tags = {
    Name    = var.subnet_tag
    Service = "Terraform"
  }
}

resource "aws_route_table" "Public-RT-Terra" {
  vpc_id = aws_vpc.Vpc-Terra.id

  route {
    cidr_block = var.rt-cidr_block
    gateway_id = aws_internet_gateway.Igw-Terra.id
  }

  tags = {
    Name    = var.rt_public_tag
    Service = "Terraform"
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
    Name    = var.sg_tag
    Service = "Terraform"
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

resource "aws_instance" "web-1" {
  ami               = "ami-0e2c8caa4b6378d8c"
  availability_zone = var.ec2_az
  instance_type     = var.ec2_type
  # key_name = "LaptopKey"
  subnet_id                   = aws_subnet.Public-Subnet-Terra.id
  vpc_security_group_ids      = ["${aws_security_group.allow-all.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "Server-1"
    Env        = "Prod"
    Owner      = "sri"
    Enterprise = "ABCD"
  }
  lifecycle {
    create_before_destroy = true
  }
}
