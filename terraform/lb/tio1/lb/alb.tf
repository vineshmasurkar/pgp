variable "vpc_id" {
  type = string
  default = "<vpc_id>"
}

variable "subnet_ids" {
  type = list(string)
  default = [ "<def_subnet_id>" ]
}

variable "aws_security_group_ids" {
  type = list(string)
  default = [ "<aws_security_group_id>" ]
}

variable "tio2-web-tg-arn" {
  type = string
  default = "<tio2-web-tg-arn>"
}

# https://www.pulumi.com/ai/answers/1iqgr8sckf3XEGQxxa6UWt/configuring-aws-load-balancer-listener-rules-with-terraform

resource "aws_lb" "tio2-web-lb" {
  name               = "web-lb"
  load_balancer_type = "application"
  security_groups    = var.aws_security_group_ids
  subnets            = [for subnet-id in var.subnet_ids : subnet-id]
  # subnets          = [for subnet in aws_subnet.lb-sbs : subnet.id]
  tags = {
    Activity = "lb-tio1"
  }
}

resource "aws_lb_listener" "tio2-web-lb-listnr" {
  load_balancer_arn = aws_lb.tio2-web-lb.arn
  port              = "80"
  protocol          = "HTTP"
  # ssl_policy        = "ELBSecurityPolicy-2016-08"
  # certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  default_action {
    type             = "forward"
    target_group_arn = var.tio2-web-tg-arn
  }
}

# output "vm_instances" {
#   value = aws_subnet.lb-sbs
# }


# variable "subnets111" {
#   type = list(object({
#     az   = string
#     azid = string
#     cidr = string
#   }))
#     default = [
#     {
#       az   = "us-east-1a"
#       azid = "use1-az1"
#       cidr = "172.31.0.0/20"
#     },
#     {
#       az   = "us-east-1b"
#       azid = "use1-az2"
#       cidr = "172.31.16.0/20"
#     },
#     {
#       az   = "us-east-1c"
#       azid = "use1-az3"
#       cidr = "172.31.32.0/20"
#     },
#     {
#       az   = "us-east-1d"
#       azid = "use1-az4"
#       cidr = "172.31.48.0/20"
#     },
#     {
#       az   = "us-east-1e"
#       azid = "use1-az5"
#       cidr = "172.31.64.0/20"
#     },
#     {
#       az   = "us-east-1f"
#       azid = "use1-az6"
#       cidr = "172.31.80.0/20"
#     }
#   ]
# }

# locals {
#  subnets = {
#    "us-east-1a" =  {
#       azid = "use1-az1",
#       cidr = "172.31.0.0/20"
#     },
#    "us-east-1b" =  {
#       azid = "use1-az2",
#       cidr = "172.31.16.0/20"
#     },
#    "us-east-1c" =  {
#       azid = "use1-az3",
#       cidr = "172.31.32.0/20"
#     },
#    "us-east-1d" =  {
#       azid = "use1-az4",
#       cidr = "172.31.48.0/20"
#     },
#    "us-east-1e" =  {
#       azid = "use1-az5",
#       cidr = "172.31.64.0/20"
#     },
#    "us-east-1f" =  {
#       azid = "use1-az6",
#       cidr = "172.31.80.0/20"
#     }
#  }
# }

# resource "aws_subnet" "lb-sbs" {
#   for_each = local.subnets
#     vpc_id               = var.vpc_id
#     availability_zone    = each.key
#     # availability_zone_id = each.value.azid
#     cidr_block           = each.value.cidr
# }

# resource "aws_default_subnet" "default_az1" {
#   availability_zone = "us-west-2a"
#   vpc_id               = var.vpc_id
#   tags = {
#     Name = "Default subnet for us-west-2a"
#   }
# }

# module "sb" {
#   source = ".sb"
#   vpc_id = var.vpc_id
# #   for_each = toset(subnets)
# }

# resource "aws_subnet" "lb-sbs" {
#   iterator = iter
#   for_each = var.subnets
#     vpc_id               = var.vpc_id
#     availability_zone    = iter.value.az
#     availability_zone_id = iter.value.azid 
#     cidr_block           = iter.value.cidr
#     tags = {
#         Name = "tio2-web-lb-subnets"
#     }
# }

