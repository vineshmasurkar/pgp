variable "pgp_ami" {
  type = string
  default = "ami-06d5e0de6baf595ca"
}

variable "pgp_instance_type" {
  type = string
  default = "t2.micro"
}

variable "instance_set" {
  type = set(string)
  default = ["httpserver1", "httpserver2"]
  #default = ["httpserver1"]
}

variable "vpc_id" {
  type = string
  default = "<vpc_id>"
}

variable "sg_name" {
  type = string
  default = "<sg_name>"
}

# EC2 instances
resource "aws_instance" "vms" {
  for_each = var.instance_set
    ami = var.pgp_ami
    instance_type     = var.pgp_instance_type
    user_data         = file("server-script.sh")
    security_groups = [var.sg_name]
    # subnet_id       = var.vpc_id
    tags = {
      Name = each.value
    }
}

output "vm_instances" {
  value = aws_instance.vms
}

# output "vm_instances_ids" {
#   value = values("${aws_instance.vms}").*.id
# }
