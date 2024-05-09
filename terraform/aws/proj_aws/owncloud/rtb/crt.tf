# variable "vpc_id" {
#   type = string
#   default = "<vpc_id>"
# }

# variable "igw-id" {
#   type = string
#   default = "<igw>"
# }

# variable "nat-id" {
#   type = string
#   default = "<igw>"
# }

# variable "pubsn-id" {
#   type = string
#   default = "<pubsn-id>"
# }

# variable "pvtsn-id" {
#   type = string
#   default = "<pctsn-id>"
# }

## PUBLIC CUSTOM ROUTE TABLE
# resource "aws_route_table" "public-crt" {
#   vpc_id = var.vpc_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = var.igw-id
#   }

#   tags = {
#     Name = "public-crt"
#     Task = "pcc-aws-proj1"
#   }
# }

# resource "aws_route_table_association" "pub-crt-sn" {
#   subnet_id = var.pubsn-id
#   route_table_id = aws_route_table.public-crt.id
# }

## PRIVATE CUSTOM ROUTE TABLE
# resource "aws_route_table" "private-crt" {
#   vpc_id = var.vpc_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = var.nat-id
#   }

#   tags = {
#     Name = "private-crt"
#     Task = "pcc-aws-proj1"
#   }
# }

# resource "aws_route_table_association" "pvt-crt-sn" {
#   subnet_id = var.pvtsn-id
#   route_table_id = aws_route_table.private-crt.id
# }