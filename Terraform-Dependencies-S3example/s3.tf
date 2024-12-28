resource "aws_s3_bucket" "srikanthterrab0001" {
  bucket = "srikanthterrab0001"

  tags = {
    Name        = "My Bucket 1"
    Environment = "Dev"
  }
  depends_on = [aws_vpc_security_group_ingress_rule.Inbound-Terra]
}

resource "aws_s3_bucket" "srikanthterrab0002" {
  bucket = "srikanthterrab0002"

  tags = {
    Name        = "My Bucket 2"
    Environment = "Dev"
  }
  depends_on = [aws_s3_bucket.srikanthterrab0001]
}

resource "aws_s3_bucket" "srikanthterrab0003" {
  bucket = "srikanthterrab0003"

  tags = {
    Name        = "My Bucket 3"
    Environment = "Dev"
  }
  depends_on = [aws_s3_bucket.srikanthterrab0002]
}
