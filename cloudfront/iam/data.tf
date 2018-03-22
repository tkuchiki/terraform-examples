data "aws_iam_server_certificate" "mycert" {
  name_prefix = "mycert"
  latest      = true
  provider    = "aws.us_east_1"
}

