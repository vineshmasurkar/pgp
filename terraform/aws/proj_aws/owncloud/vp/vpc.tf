resource "aws_vpc" "owncloud-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "owncloud-vpc"
    Task = "pcc-aws-proj1"
  }
}

output "owncloud-vpc-id" {
  value = aws_vpc.owncloud-vpc.id
}

output "owncloud-vpc-name" {
  value = aws_vpc.owncloud-vpc.arn
}

output "owncloud-vpc-drt-id" {
  value = aws_vpc.owncloud-vpc.main_route_table_id
}