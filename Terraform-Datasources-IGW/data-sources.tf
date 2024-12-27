data "aws_vpc" "Terra-Datasource" {
  id = "vpc-0d221b17cd610869c"
}

resource "aws_internet_gateway" "Terra-Datasource-IGW" {
  vpc_id = data.aws_vpc.Terra-Datasource.id

  tags = {
    Name = "Terra-Datasource-IGW"
  }
}
