data "aws_acm_certificate" "mycert" {
  domain = "dev.example.net"
  provider    = "aws.us_east_1"
  most_recent = true
}
