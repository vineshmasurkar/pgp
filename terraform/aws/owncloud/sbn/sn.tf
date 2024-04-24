variable "vpc_id" {
  type = string
  default = "<vpc_id>"
}

## PUBLIC SUBNET 
resource "aws_subnet" "public-sn" {
  availability_zone = "us-east-1a"
  vpc_id     = var.vpc_id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true # Auto-assign IP: Enable suto-assign public IPv4 address

  tags = {
    Name = "public-sn"
    Task = "pcc-aws-proj1"
  }
}

## PRIVATE SUBNET 
resource "aws_subnet" "private-sn" {
  availability_zone = "us-east-1b"
  vpc_id     = var.vpc_id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private-sn"
    Task = "pcc-aws-proj1"
  }
}

output "public-sn-id" {
  value = aws_subnet.public-sn.id
}

output "private-sn-id" {
  value = aws_subnet.private-sn.id
}