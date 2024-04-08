variable "vpc_id" {
  type = string
  default = "<vpc_id>"
}

variable "ingressrules" {
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

variable "egressrules" {
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

# Security Group
resource "aws_security_group" "tio2-sg" {
  name        = "tio2-sg"
  description = "Opens security groups for ssh and http"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
      iterator = iter
      for_each = var.ingressrules
      content {
          from_port = iter.value.port
          to_port = iter.value.port
          protocol = iter.value.protocol
          cidr_blocks = ["0.0.0.0/0"]
      }
    }
    dynamic "egress" {
      iterator = iter
      for_each = var.egressrules
      content {
          from_port = iter.value.port
          to_port = iter.value.port
          protocol = iter.value.protocol
          cidr_blocks = ["0.0.0.0/0"]
      }
  }
  tags = {
    Name = "tio2-sg"
  }
}

output "tio2-sg" {
  value = aws_security_group.tio2-sg
}

output "aws_security_group_id" {
  value = aws_security_group.tio2-sg.id
}

output "aws_security_group_name" {
  value = aws_security_group.tio2-sg.name
}
