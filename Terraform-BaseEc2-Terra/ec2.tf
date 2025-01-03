resource "aws_instance" "web-1" {
  #ami = "${data.aws_ami.my_ami.id}"
  ami                         = "ami-0e2c8caa4b6378d8c"
  availability_zone           = "us-east-1a"
  instance_type               = "t2.micro"
  key_name                    = "keypair_0125"
  subnet_id                   = aws_subnet.subnet1-public.id
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true
  tags = {
    Name       = "${var.env}Server"
    Env        = "Prod"
    Owner      = "sri"
    CostCenter = "ABCD"
  }
  lifecycle {
    #create_before_destroy = true
    #prevent_destroy = true
  }
  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install -y gnupg software-properties-common curl unzip
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update -y
    sudo apt-get install -y terraform
    terraform --version
    sudo apt-get install -y nginx
    echo "<h1>${var.env}-Server</h1>" | sudo tee /var/www/html/index.html
    sudo systemctl start nginx
    sudo systemctl enable nginx
    terraform --version
  EOF
}
