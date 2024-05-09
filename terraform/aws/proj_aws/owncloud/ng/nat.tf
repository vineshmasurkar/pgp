variable "vpc_id" {
  type = string
  default = "<vpc_id>"
}

variable "pubsn-id" {
  type = string
  default = "<pubsn-id>"
}

variable "pvtsn-id" {
  type = string
  default = "<pvtsn-id>"
}

resource "aws_eip" "nat-eip" {
  domain = "vpc"
  # vpc = true
 
  tags = {
    Name = "eip-nat"
    Task = "pcc-aws-proj1"
  }
}

resource "aws_nat_gateway" "owncloud-nat" {
  subnet_id = var.pubsn-id
  connectivity_type = "public"
  allocation_id = aws_eip.nat-eip.id

  tags = {
    Name = "owncloud-nat"
    Task = "pcc-aws-proj1"
  }
}

## PRIVATE CUSTOM ROUTE TABLE
## Instead of using a private crt...
##  add a route to the vpc's def rt 
##  and associate it with the private subnet 
resource "aws_route_table" "private-crt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.owncloud-nat.id
  }

  tags = {
    Name = "private-crt"
    Task = "pcc-aws-proj1"
  }
}

resource "aws_route_table_association" "pvt-crt-sn" {
  subnet_id = var.pvtsn-id
  route_table_id = aws_route_table.private-crt.id
}

output "owncloud-nat-id" {
  value = aws_nat_gateway.owncloud-nat.id
}