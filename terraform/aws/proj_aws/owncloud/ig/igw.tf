variable "vpc_id" {
  type = string
  default = "<vpc_id>"
}

variable "pubsn-id" {
  type = string
  default = "<pubsn-id>"
}

resource "aws_internet_gateway" "owncloud-igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "owncloud-igw"
    Task = "pcc-aws-proj1"
  }
}

resource "aws_route_table" "public-crt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.owncloud-igw.id
  }

  tags = {
    Name = "public-crt"
    Task = "pcc-aws-proj1"
  }
}

resource "aws_route_table_association" "pub-crt-sn" {
  subnet_id = var.pubsn-id
  route_table_id = aws_route_table.public-crt.id
}

output "owncloud-igw-id" {
  value = aws_internet_gateway.owncloud-igw.id
}