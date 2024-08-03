provider "aws" {
  region = "us-east-1"  # US East (N. Virginia)
}

## DATA...#####################################################
data "aws_vpc" "def_vpc" {
  default = true
}

# data "aws_subnet_ids" "all" {
#   vpc_id = data.aws_vpc.def_vpc.id
# } 

data "aws_subnet" "default" {
  vpc_id = data.aws_vpc.def_vpc.id
} 

## MODULES...#####################################################
module "role" {
  source = "./iam"
}

# module "ec2" {
#    source = "./vm"
#    vpc_id = data.aws_vpc.def_vpc.id
#    ec2_role_profile_name = module.role.ec2_role_profile.name
# }

## RESOURCES...#####################################################


## OUTPUTS...#####################################################
output "def_vpc" {
  value = data.aws_vpc.def_vpc
}

output "def_vpc_subnets" {
  value = data.aws_subnet.default.id
}

output "ec2_role_arn" {
  value = module.role.ec2_role.arn
}

output "ec2_multirole_profile" {
  value = module.role.ec2_role_profile
}

# output "dev-server_id" {
#   value = module.ec2.dev-server.id
# }