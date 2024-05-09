variable "vpc_id" {
  type = string
  default = "<vpc_id>"
}

resource "aws_internet_gateway" "owncloud-igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "owncloud-igw"
    Task = "pcc-aws-proj1"
  }
}

output "owncloud-igw-id" {
  value = aws_internet_gateway.owncloud-igw.id
}