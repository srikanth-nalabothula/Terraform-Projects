resource "aws_instance" "web-1" {
  ami               = "ami-0e2c8caa4b6378d8c"
  availability_zone = "us-east-1a"
  instance_type     = "t2.micro"
  # key_name = "LaptopKey"
  subnet_id                   = data.aws_subnet.Terraform_Public_Subnet1-testing.id
  vpc_security_group_ids      = ["${data.aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "Server-1"
    Env        = "Prod"
    Owner      = "sri"
    Enterprise = "ABCD"
  }
  #  user_data = <<- EOF
  #  #!/bin/bash
  #  	sudo apt-get update
  #  	sudo apt-get install -y nginx
  #  	echo "<h1>${var.env}-Server-1</h1>" | sudo tee /var/www/html/index.html
  #  	sudo systemctl start nginx
  #  	sudo systemctl enable nginx
  #  EOF

}

terraform {
  backend "s3" {
    bucket = "srikanth-terraform"
    key    = "Current-Infra.tfstate"
    region = "us-east-1"
  }
}
