################################################################################
# VPC Module
################################################################################


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  providers = {
    aws = aws.eu-west-1
  }

  azs = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets

  enable_nat_gateway = var.vpc_nat_gateway

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}
