variable "ami" {
  type = string
  default = "ami-0eb199b995e2bc4e3" # Ubuntu, 20.04 LTS (64-bit (x86))
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "vpc_id" {
  type = string
  default = "<vpc_id>"
}

variable "sg_name" {
  type = string
  default = "<sg_name>"
}

variable "sg_id" {
  type = string
  default = "<sg_id>"
}

variable "ls-sn-id" {
  type = string
  default = "<ls-sn_id>"
}

# EC2 instances
resource "aws_instance" "liftshift-app-1" {
  ami               = var.ami
  instance_type     = var.instance_type
  # security_groups   = [var.sg_name]
  vpc_security_group_ids  = [var.sg_id]
  subnet_id         = var.ls-sn-id
  user_data         = file("server-script.sh")

  tags = {
    Name = "liftshift-app-1"
  }
}

resource "aws_instance" "liftshift-app-2" {
  ami               = var.ami
  instance_type     = var.instance_type
  security_groups   = [var.sg_name]
  subnet_id         = "us-west-1a"
  user_data         = file("server-script.sh")

  tags = {
    Name = "liftshift-app-2"
  }
}

# output "vm_instances" {
#   value = aws_instance.vms
# }
