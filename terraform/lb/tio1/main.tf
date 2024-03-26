provider "aws" {
  region = "us-east-1"
}

variable "pgp_ami" {
  type = string
  default = "ami-06d5e0de6baf595ca"
}

variable "pgp_instance_type" {
  type = string
  default = "t2.micro"
}

data "aws_vpc" "default" {
  default = true
}

variable "instance_set" {
  type = set(string)
  default = ["httpserver1", "httpserver2"]
  #default = ["httpserver1"]
}

# EC2 instances
resource "aws_instance" "by_set" {
  for_each = var.instance_set
    ami = var.pgp_ami
    instance_type     = var.pgp_instance_type
    user_data         = file("server-script.sh")
    security_groups = [aws_security_group.tio2-sg.name]
    tags = {
      Name = each.value
    }
}

# Security Group
resource "aws_security_group" "tio2-sg" {
  name        = "tio2-sg"
  description = "Opens security groups for ssh and http"
  vpc_id      = data.aws_vpc.default.id
  tags = {
    Name = "tio2-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.tio2-sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = "http"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.tio2-sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
}

# output "ec2_instance_id111" {
#   value = tomap({
#     values(aws_instance.by_set).* = values(aws_instance.by_set).*.id
#   })
# }

# output "ec2_instance_id" {
#   value = values(aws_instance.by_set).*.id
# }

# output "ec2_instance_sg_id" {
#   value = values(aws_instance.by_set).*.security_groups
# }

# output "ec2_instance_public_ip" {
#   value = values(aws_instance.by_set).*.public_ip
# }

# output "aws_security_group_id" {
#   value = aws_security_group.tio2-sg.id
# }