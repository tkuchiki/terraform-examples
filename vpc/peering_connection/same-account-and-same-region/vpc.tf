resource "aws_vpc" "requester" {
  cidr_block       = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "Requester"
  }
}

resource "aws_vpc" "accepter" {
  cidr_block       = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "Accepter"
  }
}

resource "aws_vpc_peering_connection" "peer" {
  peer_owner_id = "${var.aws_account_id}"
  peer_vpc_id   = "${aws_vpc.accepter.id}"
  vpc_id        = "${aws_vpc.requester.id}"

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  auto_accept = true
}
