resource "aws_vpc" "requester" {
  cidr_block       = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "Requester"
  }
}

resource "aws_vpc_peering_connection" "peer" {
  peer_owner_id = "${var.aws_account_id}"
  peer_vpc_id   = "${var.accepter_aws_account_id}"
  peer_region   = "us-east-1"
  vpc_id        = "${aws_vpc.requester.id}"
  auto_accept = false

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }


  tags {
    Side = "Requester"
  }
}

resource "aws_vpc_peering_connection_accepter" "peer_accepter" {
  provider                  = "aws.us_east_1"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"
  auto_accept               = true
  

  tags {
    Side = "Accepter"
  }
}
