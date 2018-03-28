resource "aws_vpc" "bastion" {
  cidr_block       = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags {
    Name = "bastion dev"
  }
}

resource "aws_subnet" "bastion_public_az_a" {
  vpc_id     = "${aws_vpc.bastion.id}"
  cidr_block = "10.1.1.0/24"

  tags {
    Name = "bastion public az-a"
  }
}

resource "aws_subnet" "bastion_public_az_c" {
  vpc_id     = "${aws_vpc.bastion.id}"
  cidr_block = "10.1.2.0/24"

  tags {
    Name = "bastion public az-c"
  }
}

resource "aws_subnet" "bastion_private_az_a" {
  vpc_id     = "${aws_vpc.bastion.id}"
  cidr_block = "10.1.11.0/24"

  tags {
    Name = "bastion private az-a"
  }
}

resource "aws_subnet" "bastion_private_az_c" {
  vpc_id     = "${aws_vpc.bastion.id}"
  cidr_block = "10.1.12.0/24"

  tags {
    Name = "bastion private az-c"
  }
}

resource "aws_route_table" "bastion_public" {
  vpc_id = "${aws_vpc.bastion.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.bastion.id}"
  }

  tags {
    Name = "bastion public"
  }
}

resource "aws_route_table" "bastion_private" {
  vpc_id = "${aws_vpc.bastion.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.bastion.id}"
  }

  tags {
    Name = "bstion private"
  }
}

resource "aws_internet_gateway" "bastion" {
  vpc_id = "${aws_vpc.bastion.id}"

  tags {
    Name = "main"
  }
}

resource "aws_nat_gateway" "bastion" {
  allocation_id = "${aws_eip.bastion_nat_gateway.id}"
  subnet_id     = "${aws_subnet.bastion_private_az_a.id}"

  tags {
    Name = "bastion NAT Gateway"
  }
}

resource "aws_main_route_table_association" "bastion_public" {
  vpc_id         = "${aws_vpc.bastion.id}"
  route_table_id = "${aws_route_table.bastion_public.id}"
}

resource "aws_route_table_association" "bastion_public_az_a" {
  subnet_id      = "${aws_subnet.bastion_public_az_a.id}"
  route_table_id = "${aws_route_table.bastion_public.id}"
}

resource "aws_route_table_association" "bastion_public_az_c" {
  subnet_id      = "${aws_subnet.bastion_public_az_c.id}"
  route_table_id = "${aws_route_table.bastion_public.id}"
}

resource "aws_route_table_association" "bastion_private_az_a" {
  subnet_id      = "${aws_subnet.bastion_private_az_a.id}"
  route_table_id = "${aws_route_table.bastion_private.id}"
}

resource "aws_route_table_association" "bastion_private_az_c" {
  subnet_id      = "${aws_subnet.bastion_private_az_c.id}"
  route_table_id = "${aws_route_table.bastion_private.id}"
}
