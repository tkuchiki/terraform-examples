data "aws_iam_policy_document" "dev2" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.dev.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.bucket_name}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.dev.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket" "dev" {
  bucket = "${var.bucket_name}"
  acl    = "private"
  policy = "${data.aws_iam_policy_document.dev.json}"
}
