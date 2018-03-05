resource "aws_alb" "dev" {
  name            = "dev-alb"
  internal        = false
  security_groups = ["${aws_security_group.dev_alb.id}"]
  subnets         = ["${var.subnet_id_1}", "${var.subnet_id_2}"]

  enable_deletion_protection = true
}

resource "aws_alb_listener" "dev_https" {
  load_balancer_arn = "${aws_alb.dev.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${data.aws_acm_certificate.your_cert.arn}"
  
  default_action {
    target_group_arn = "${aws_alb_target_group.dev_ec2.arn}"
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "dev_https" {
  listener_arn = "${aws_alb_listener.dev_https.arn}"
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.dev_ec2.arn}"
  }

  condition {
    field = "path-pattern"
    values = ["/*"]
  }
}

resource "aws_alb_target_group" "dev_ec2" {
  name     = "dev-ec2"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  deregistration_delay = 60
  target_type = "ip"

  health_check {
    interval = 6
    path = "/healthcheck"
    protocol = "HTTP"
    timeout = 5
    healthy_threshold = 5
    unhealthy_threshold = 5
    matcher= 200
  }
}
