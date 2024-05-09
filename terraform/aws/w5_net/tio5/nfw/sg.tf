variable "vpc_id" {
  type = string
  default = "<vpc_id>"
}

## Security Group Rules for ownCloud app
variable "pub-io-rules" {
  type = list(object({
    port     = number
    protocol = string
    cidr_block = string
  }))
  default = [
    {
      port     = 22
      protocol = "tcp"
      cidr_block = "0.0.0.0/0"
    },
    {
      port     = 80
      protocol = "tcp"
      cidr_block = "0.0.0.0/0"
    }
  ]
}

## Security Group Rules for MySQL DB
variable "pvt-io-rules" {
  type = list(object({
    port     = number
    protocol = string
    cidr_block = string
  }))
  default = [
    {
      port     = 22
      protocol = "tcp"
      cidr_block = "10.0.1.0/24"
    },
    {
      port     = 3306   # MYSQL/ Aurora
      protocol = "tcp"
      cidr_block = "10.0.1.0/24"
    }
  ]
}

## PUBLIC SECURITY GROUP for ownCloud app
resource "aws_security_group" "public-server-sg" {
  name        = "public-server-sg"
  description = "Opens port(s) for SSH and HTTP"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
      iterator = iter
      for_each = var.pub-io-rules
      content {
          from_port = iter.value.port
          to_port = iter.value.port
          protocol = iter.value.protocol
          cidr_blocks = [iter.value.cidr_block]
      }
    }
    dynamic "egress" {
      iterator = iter
      for_each = var.pub-io-rules
      content {
          from_port = iter.value.port
          to_port = iter.value.port
          protocol = iter.value.protocol
          cidr_blocks = [iter.value.cidr_block]
      }
  }

  tags = {
    Name = "public-server-sg"
    Task = "pcc-aws-proj1"
  }
}

## PRIVATE SECURITY GROUP for MySQL DB
resource "aws_security_group" "private-server-sg" {
  name        = "private-server-sg"
  description = "Opens port(s) for SSH and MYSQL"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
      iterator = iter
      for_each = var.pvt-io-rules
      content {
          from_port = iter.value.port
          to_port = iter.value.port
          protocol = iter.value.protocol
          cidr_blocks = [iter.value.cidr_block]
      }
    }
    dynamic "egress" {
      iterator = iter
      for_each = var.pvt-io-rules
      content {
          from_port = iter.value.port
          to_port = iter.value.port
          protocol = iter.value.protocol
          cidr_blocks = [iter.value.cidr_block]
      }
  }

  tags = {
    Name = "private-server-sg"
    Task = "pcc-aws-proj1"
  }
}

##-------------------------------------------------------
output "public-server-sg" {
  value = aws_security_group.public-server-sg
}

output "public-server-sg_id" {
  value = aws_security_group.public-server-sg.id
}

output "public-server-sg_name" {
  value = aws_security_group.public-server-sg.name
}

output "private-server-sg" {
  value = aws_security_group.private-server-sg
}

output "private-server-sg_id" {
  value = aws_security_group.private-server-sg.id
}

output "private-server-sg_name" {
  value = aws_security_group.private-server-sg.name
}
