#This Terraform Code Deploys Basic VPC Infra.
provider "aws" {
  # access_key = "${var.aws_access_key}"
  # secret_key = "${var.aws_secret_key}"
  region = var.aws_region
}

# terraform {
#   backend "s3" {
#     bucket = "srikanth-terraform"
#     key    = "Base-Infra.tfstate"
#     region = "us-east-1"
#   }
# }


resource "aws_vpc" "Terra-Vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name  = "${var.vpc_name}"
    Owner = "Srikanth"
  }
}

resource "aws_internet_gateway" "Terra-IGW" {
  vpc_id = aws_vpc.Terra-Vpc.id
  tags = {
    Name = "${var.IGW_name}"
  }
}

resource "aws_subnet" "subnet1-public" {
  vpc_id            = aws_vpc.Terra-Vpc.id
  cidr_block        = var.public_subnet1_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.public_subnet1_name}"
  }
}

# resource "aws_subnet" "subnet2-public" {
#   vpc_id            = aws_vpc.Terra-Vpc.id
#   cidr_block        = var.public_subnet2_cidr
#   availability_zone = "us-east-1b"

#   tags = {
#     Name = "${var.public_subnet2_name}"
#   }
# }

# resource "aws_subnet" "subnet3-public" {
#   vpc_id            = aws_vpc.Terra-Vpc.id
#   cidr_block        = var.public_subnet3_cidr
#   availability_zone = "us-east-1c"

#   tags = {
#     Name = "${var.public_subnet3_name}"
#   }

# }

resource "aws_route_table" "terraform-public" {
  vpc_id = aws_vpc.Terra-Vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Terra-IGW.id
  }

  tags = {
    Name = "${var.Main_Routing_Table}"
  }
}

resource "aws_route_table_association" "terraform-public" {
  subnet_id      = aws_subnet.subnet1-public.id
  route_table_id = aws_route_table.terraform-public.id
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.Terra-Vpc.id
  tags = {
    Name = "allow_all"
  }
}

resource "aws_vpc_security_group_ingress_rule" "Inbound-Terra" {
  security_group_id = aws_security_group.allow_all.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 0
}

resource "aws_vpc_security_group_egress_rule" "Outbound-Terra" {
  security_group_id = aws_security_group.allow_all.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 0
}
