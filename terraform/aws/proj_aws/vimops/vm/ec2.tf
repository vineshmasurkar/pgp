variable "pgp_ami" {
  type = string
  default = "ami-080e1f13689e07408" # Ubuntu Server 22.04 LTS (64-bit (x86))
}

variable "pgp_instance_type" {
  type = string
  default = "t2.micro"
}

variable "vpc_id" {
  type = string
  default = "<vpc_id>"
}

variable "ec2_role_profile_name" {
  type = string
  default = "<ec2_multirole_profile_name>"
}

# variable "pub-sn-id" {
#   type = string
#   default = "<pub-sn-id>"
# }

# variable "pvt-sn-id" {
#   type = string
#   default = "<pvt-sn-id>"
# }

# variable "pub-sg-name" {
#   type = string
#   default = "<pub-sg-name>"
# }

# variable "pub-sg-id" {
#   type = string
#   default = "<pub-sg-id>"
# }

# variable "pvt-sg-name" {
#   type = string
#   default = "<pvt-sg-name>"
# }

# variable "pvt-sg-id" {
#   type = string
#   default = "<pvt-sg-id>"
# }

## EC2 instances for dev server
resource "aws_instance" "dev-server" {
    ami                     = var.pgp_ami
    instance_type           = var.pgp_instance_type
    key_name                = "pgp-lab-key"  # DONOT add ext .pem

    iam_instance_profile    = var.ec2_role_profile_name 
    # subnet_id               = var.pub-sn-id    
    # security_groups         = [var.pub-sg-name] # used for default vpc
    # vpc_security_group_ids  = [var.pub-sg-id]     # used for custom vpc
    # associate_public_ip_address = true

    # user_data = file("public-server-script.sh")

    tags = {
      Name = "dev-server"
      Task = "pcc-aws-proj2"
    }
}

## PRIVATE EC2 instances for MySQL DB
# resource "aws_instance" "private-server" {
#     ami                     = var.pgp_ami
#     instance_type           = var.pgp_instance_type
#     key_name                = "private-server-kp"  # DONOT add ext .pem

#     subnet_id               = var.pvt-sn-id
#     # security_groups         = [var.pub-sg-name]  # used for default vpc
#     vpc_security_group_ids  = [var.pvt-sg-id]      # used for custom vpc
#     # vpc_security_group_ids  = [var.pvt-sg-id]    # 

#     # user_data = file("xxxx.sh")                 # no User data script

#     tags = {
#       Name = "private-server"
#       Task = "pcc-aws-proj1"
#     }
# }

##-------------------------------------------------------
output "dev-server" {
  value = aws_instance.dev-server
}

# output "private-server-instance" {
#   value = aws_instance.private-server
# }