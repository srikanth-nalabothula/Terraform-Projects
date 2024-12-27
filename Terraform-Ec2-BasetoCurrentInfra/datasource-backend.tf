data "aws_vpc" "terraform-aws-testing" {
  id = "vpc-03c0354aaa7a7a924"
}

data "aws_subnet" "Terraform_Public_Subnet1-testing" {
  id = "subnet-05af0e77b74faa618"
}

data "aws_security_group" "allow_all" {
  id = "sg-01400e660846d806d"
}
