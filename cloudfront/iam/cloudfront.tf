resource "aws_cloudfront_origin_access_identity" "dev" {
  comment = "Some comment"
}

resource "aws_cloudfront_distribution" "dev" {
  origin {
    domain_name = "${aws_s3_bucket.dev.bucket_domain_name}"
    origin_id   = "${aws_s3_bucket.dev.bucket_domain_name}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.dev.cloudfront_access_identity_path}"
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"

  aliases = ["dev.example.com"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${aws_s3_bucket.dev.bucket_domain_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # for SPA
  custom_error_response {
    error_code = 403
    response_code = 200
    response_page_path = "/index.html"
  }

  # for SPA
  custom_error_response {
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1"
    iam_certificate_id = "${data.aws_iam_server_certificate.mycert.id}"
  }
}
