variable "vpc_id" {
  type = string
  default = "<vpc_id>"
}

variable "pub-io-rules" {
  type = list(object({
    port     = number
    protocol = string
  }))
  default = [
    {
      port     = 22
      protocol = "tcp"
    },
    {
      port     = 80
      protocol = "tcp"
    }
  ]
}

variable "pvt-io-rules" {
  type = list(object({
    port     = number
    protocol = string
  }))
  default = [
    {
      port     = 22
      protocol = "tcp"
    }
  ]
}

## PUBLIC SECUIRTY GROUP 
resource "aws_security_group" "public-server-sg" {
  name        = "public-server-sg"
  description = "Opens ports for SSH and HTTP"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
      iterator = iter
      for_each = var.pub-io-rules
      content {
          from_port = iter.value.port
          to_port = iter.value.port
          protocol = iter.value.protocol
          cidr_blocks = ["0.0.0.0/0"]
      }
    }
    dynamic "egress" {
      iterator = iter
      for_each = var.pub-io-rules
      content {
          from_port = iter.value.port
          to_port = iter.value.port
          protocol = iter.value.protocol
          cidr_blocks = ["0.0.0.0/0"]
      }
  }

  tags = {
    Name = "public-server-sg"
    Task = "pcc-aws-proj1"
  }
}

## PRIVATE SECUIRTY GROUP 
resource "aws_security_group" "private-server-sg" {
  name        = "private-server-sg"
  description = "Opens port for SSH only"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
      iterator = iter
      for_each = var.pvt-io-rules
      content {
          from_port = iter.value.port
          to_port = iter.value.port
          protocol = iter.value.protocol
          cidr_blocks = ["0.0.0.0/0"]
      }
    }
    dynamic "egress" {
      iterator = iter
      for_each = var.pvt-io-rules
      content {
          from_port = iter.value.port
          to_port = iter.value.port
          protocol = iter.value.protocol
          cidr_blocks = ["0.0.0.0/0"]
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
