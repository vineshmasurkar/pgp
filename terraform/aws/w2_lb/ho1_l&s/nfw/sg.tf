variable "vpc_id" {
  type = string
  default = "<vpc_id>"
}

variable "io-rules" {
  type = list(object({
    port     = number
    protocol = string
    cidr     = string
  }))
  default = [
    {
      port     = 80
      protocol = "tcp"
      cidr     = "0.0.0.0/0"
    }
  ]
}

# variable "egressrules" {
#   type = list(object({
#     port     = number
#     protocol = string
#   }))
#   default = [
#     {
#       port     = 22
#       protocol = "tcp"
#     },
#     {
#       port     = 80
#       protocol = "tcp"
#     }
#   ]
# }

# Security Group
resource "aws_security_group" "open-http-sg" {
  name        = "tio2-sg"
  description = "Opens security groups for SSH"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
      iterator = iter
      for_each = var.io-rules
      content {
          from_port = iter.value.port
          to_port = iter.value.port
          protocol = iter.value.protocol
          cidr_blocks = [iter.value.cidr]
      }
    }
    dynamic "egress" {
      iterator = iter
      for_each = var.io-rules
      content {
          from_port = iter.value.port
          to_port = iter.value.port
          protocol = iter.value.protocol
          cidr_blocks = [iter.value.cidr]
      }
  }

  tags = {
    Name = "open-http-sg"
  }
}

output "open-http-sg" {
  value = aws_security_group.open-http-sg
}

output "open-http-sg_id" {
  value = aws_security_group.open-http-sg.id
}

output "open-http-sg_name" {
  value = aws_security_group.open-http-sg.name
}