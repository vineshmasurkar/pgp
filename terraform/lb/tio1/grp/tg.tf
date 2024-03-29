variable "vpc_id" {
  type = string
  default = "<vpc_id>"
}

variable "vm_instances" {
  type = map
  default = {
    "key" = "value"
  }
}

resource "aws_lb_target_group_attachment" "tio2-web-tga" {
  for_each = tomap(var.vm_instances)
    target_group_arn  = aws_lb_target_group.tio2-web-tg.arn
    target_id = tostring(each.value.id)
    port = 80
}

resource "aws_lb_target_group" "tio2-web-tg" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id   = var.vpc_id

  health_check {
    enabled = true
    path = "/health.html"
    healthy_threshold = 2
    timeout = 3
  }
}