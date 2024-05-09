provider "aws" {
  region = "us-east-1"  # US East (N. Virginia)
}

module "vpc" {
  source = "./vp"
}

module "sn" {
  source = "./sbn"
  vpc_id = module.vpc.owncloud-vpc-id
}

module "igw" {
  source = "./ig"
  vpc_id = module.vpc.owncloud-vpc-id
}

# module "nat" {
#   source = "./ng"
#   vpc_id = module.vpc.owncloud-vpc-id
#   pubsn-id = module.sn.public-sn-id
#   pvtsn-id = module.sn.private-sn-id
# }

module "crt" {
  source = "./rtb"
  vpc_id = module.vpc.owncloud-vpc-id
  igw-id = module.igw.owncloud-igw-id
#  nat-id = module.nat.owncloud-nat-id
  pubsn-id = module.sn.public-sn-id
  pvtsn-id = module.sn.private-sn-id
}

module "sg" {
  source = "./nfw"
  vpc_id = module.vpc.owncloud-vpc-id
}

module "ec2" {
  source = "./vm"
  vpc_id = module.vpc.owncloud-vpc-id
  pub-sn-id = module.sn.public-sn-id
  pvt-sn-id = module.sn.private-sn-id
  pub-sg-name = module.sg.public-server-sg_name
  pub-sg-id = module.sg.public-server-sg_id
  pvt-sg-name = module.sg.private-server-sg_name
  pvt-sg-id = module.sg.private-server-sg_id
}

##-------------------------------------------------------
output "vpc-id" {
  value = module.vpc.owncloud-vpc-id
}