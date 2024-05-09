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

resource "aws_eip" "eip-nat" {
  domain = "vpc"
  # vpc = true
 
  tags = {
    Name = "eip-nat"
    Task = "pcc-aws-proj1"
  }
}

resource "aws_nat_gateway" "owncloud-nat" {
  subnet_id = var.pubsn-id
  allocation_id = aws_eip.eip-nat.id

  tags = {
    Name = "owncloud-nat"
    Task = "pcc-aws-proj1"
  }
}

output "owncloud-nat-id" {
  value = aws_nat_gateway.owncloud-nat.id
}