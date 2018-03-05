# ACM
data "aws_acm_certificate" "your_cert" {
  domain = "*.example.com"
  most_recent = true
}

# AZ
data "aws_availability_zones" "available" {}
