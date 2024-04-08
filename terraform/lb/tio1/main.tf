provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

########################################################################
# module "vpc" {
#   source = "./pc"
#   vpc_id = data.aws_vpc.default.id
# }

# variable "aws_vpc_id" {
#   type = string
#   default = "<aws_vpc_id>"
# }


# data "aws_subnet" "selected" {
#   vpc_id = data.aws_vpc.default.id

#   # filter {
#   #   name    = "subnet-id"
#   #   values  = [data.aws_vpc.default.id]
#   # }
# }
########################################################################


locals {
 subnets = {
   "us-east-1a" =  {
      azid = "use1-az1",
      cidr = "172.31.0.0/20"
    },
   "us-east-1b" =  {
      azid = "use1-az2",
      cidr = "172.31.16.0/20"
    },
   "us-east-1c" =  {
      azid = "use1-az3",
      cidr = "172.31.32.0/20"
    },
   "us-east-1d" =  {
      azid = "use1-az4",
      cidr = "172.31.48.0/20"
    },
   "us-east-1e" =  {
      azid = "use1-az5",
      cidr = "172.31.64.0/20"
    },
   "us-east-1f" =  {
      azid = "use1-az6",
      cidr = "172.31.80.0/20"
    }
 }
}

resource "aws_default_subnet" "vpc-sbs" {
  for_each = local.subnets
    # vpc_id              = data.aws_vpc.default.id
    availability_zone   = each.key
    # cidr_block          = each.value.cidr
}

output "subnet_ids" {
    value = [for subnet in aws_default_subnet.vpc-sbs : subnet.id]
}

# variable "subnet_ids" {
#   type = list(string)
#   default = [for subnet in aws_default_subnet.vpc-sbs : subnet.id]
# }

module "sg" {
  source = "./fw"
  vpc_id = data.aws_vpc.default.id
}

module "ec2" {
  source = "./vm"
  vpc_id = data.aws_vpc.default.id
  sg_name = module.sg.aws_security_group_name
}

module "tg" {
  source = "./grp"
  vpc_id = data.aws_vpc.default.id
  vm_instances = module.ec2.vm_instances
}

module "alb" {
  source = "./lb"
  vpc_id = data.aws_vpc.default.id
  aws_security_group_ids = [module.sg.aws_security_group_id]
  tio2-web-tg-arn = module.tg.tio2-web-tg-arn
  # tio2-web-tg-arn = var.tio2-web-tg-arn
  subnet_ids = [for subnet in aws_default_subnet.vpc-sbs : subnet.id]
}

output "return_aws_security_group_id" {
  value = module.sg.aws_security_group_id
  # value = var.aws_security_group_id
}

output "aws_vpc_id" {
  value = data.aws_vpc.default.id
}

output "tio2-web-tg-arn" {
  value = module.tg.tio2-web-tg-arn
}


# output "inst-len" {
#   value = length("${module.ec2.vm_instances}")
# }

# output "ec2_instance_ids" {
#   value = values("${module.ec2.vm_instances}").*.id
# }

# output "ec2_instance_sg_ids" {
#   value = values("${module.ec2.vm_instances}").*.security_groups
# }

# output "ec2_instance_public_ips" {
#   value = values("${module.ec2.vm_instances}").*.public_ip
# }
