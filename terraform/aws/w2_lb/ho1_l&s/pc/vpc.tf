# variable "vpc_id" {
#   type = string
#   default = "<vpc_id>"
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

# resource "aws_default_subnet" "vpc-sbs" {
#   for_each = local.subnets
#     # vpc_id              = data.aws_vpc.default.id
#     availability_zone   = each.key
#     # cidr_block          = each.value.cidr
# }

# output "subnet_ids" {
#     value = [for subnet in aws_default_subnet.vpc-sbs : subnet.id]
# }

# output "aws_vpc_id" {
#   value = var.vpc_id
# }

# output "aws_vpc_id" {
#   value = data.aws_vpc.default.id
# }