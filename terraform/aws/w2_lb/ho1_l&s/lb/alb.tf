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

resource "aws_lb" "tio2-web-lb" {
  name               = "web-lb"
  load_balancer_type = "application"
  security_groups    = var.aws_security_group_ids
  subnets            = [for subnet-id in var.subnet_ids : subnet-id]
  tags = {
    Activity = "lb-tio1"
  }
}

## https://www.pulumi.com/ai/answers/1iqgr8sckf3XEGQxxa6UWt/configuring-aws-load-balancer-listener-rules-with-terraform
resource "aws_lb_listener" "tio2-web-lb-listnr" {
  load_balancer_arn = aws_lb.tio2-web-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = var.tio2-web-tg-arn
  }
}
