################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "./vpc"

  main-region = var.main-region
  profile     = var.profile

  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  vpc_azs = var.vpc_azs
  vpc_private_subnets = var.vpc_private_subnets
  vpc_public_subnets  = var.vpc_public_subnets
  vpc_nat_gateway = var.vpc_nat_gateway
}

################################################################################
# EC2  Module
################################################################################

module "ec2" {
  source = "./ec2"
  ec2_ami_id = var.ec2_ami_id
  ec2_vm_name = var.ec2_vm_name
  ec2_fqdn = var.ec2_fqdn
  ec2_user_public_rsa = var.ec2_user_public_rsa
  ec2_instance_type = var.ec2_instance_type
  ec2_key_name = var.ec2_key_name
  ec2_subnet_id = module.vpc.public_subnets[0] # setting the VM in pubic subnet
  depends_on = [module.vpc.vpc_id]
}

################################################
# 3 -  Default SG in VPC adding ingress/egress (For simplicity) 
#           This is a bad practice
#           Better to create a separate SG for the VM
#  Ingress: ssh, http, httpS
#  Egress: outbound traffic
################################################

data "aws_security_group" "selected" {
  vpc_id = [module.vpc.vpc_id]

  filter {
    name   = "group-name"
    values = ["default"]
  }
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "http"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.selected.id
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "https"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.selected.id
}

resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "ssh"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.selected.id
}

resource "aws_security_group_rule" "www" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.selected.id
}