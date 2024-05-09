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

# Get default security group from the account filtering by name
data "aws_security_group" "selected" {
  vpc_id = data.aws_vpc.default.id

  filter {
    name    = "group-name"
    values  = ["default"]
  }
}

output "ec2_instance_id" {
  value = aws_instance.web_server.id
}

output "ec2_instance_sg_id" {
  value = aws_instance.web_server.security_groups
}

output "ec2_instance_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "aws_security_group_id" {
  value = data.aws_security_group.selected.id
}

resource "aws_instance" "web_server" {
  ami               = var.pgp_ami
  instance_type     = var.pgp_instance_type
  user_data         = file("server-script.sh")
  vpc_security_group_ids = [
                            aws_security_group.tio1-sig.id, 
                            data.aws_security_group.selected.id
                           ]
  tags = {
    Name = "httpserver1"
  }
}

resource "aws_security_group" "tio1-sig" {
  name        = "tio1-sg"
  description = "Opens security groups for ssh and http"
  vpc_id      = data.aws_vpc.default.id
  tags = {
    Name = "tio1-sig"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.tio1-sig.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

# resource "aws_vpc_security_group_ingress_rule" "allow_https" {
#   security_group_id = aws_security_group.tio1-sig.id
#   cidr_ipv4 = "0.0.0.0/0"
#   from_port = 443
#   to_port = 443
#   ip_protocol = "tcp"
# }

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.tio1-sig.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 22
  to_port = 22
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4" {
  security_group_id = aws_security_group.tio1-sig.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "-1"
}
