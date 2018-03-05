# Sercurity Group
## ALB
resource "aws_security_group" "dev_alb" {
  name        = "dev-alb"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_security_group_rule" "dev_alb" {
  type             = "ingress"
  from_port        = 443
  to_port          = 443
  protocol         = "tcp"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = "${aws_security_group.dev_alb.id}"
}

resource "aws_security_group_rule" "dev_alb_outbound" {
  type             = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = -1
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = "${aws_security_group.dev_alb.id}"
}

## EC2
resource "aws_security_group" "dev_ec2" {
  name        = "dev-ec2"
  vpc_id      = "${var.vpc_id}"
}

resource "aws_security_group_rule" "dev_ec2" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  source_security_group_id = "${aws_security_group.dev_alb.id}"

  security_group_id = "${aws_security_group.dev_ec2.id}"
}

resource "aws_security_group_rule" "dev_ec2_outbound" {
  type             = "egress"
  from_port        = 0
  to_port          = 0
  protocol         = -1
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = "${aws_security_group.dev_ec2.id}"
}
