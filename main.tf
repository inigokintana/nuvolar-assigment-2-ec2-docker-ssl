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
