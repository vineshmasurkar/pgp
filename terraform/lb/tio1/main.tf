provider "aws" {
  region = "us-east-1"
}

module "sg" {
  source = "./fw"
}

module "ec2" {
  source = "./vm"
  sg_name = module.sg.aws_security_group_name
}

module "tg" {
  source = "./grp"
  vpc_id = module.sg.aws_vpc.id
  vm_instances = module.ec2.vm_instances
}

output "inst-len" {
  value = length("${module.ec2.vm_instances}")
}

output "ec2_instance_ids" {
  value = values("${module.ec2.vm_instances}").*.id
}

output "ec2_instance_sg_ids" {
  value = values("${module.ec2.vm_instances}").*.security_groups
}

output "ec2_instance_public_ips" {
  value = values("${module.ec2.vm_instances}").*.public_ip
}
