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
# 3 -  SG in VPC adding ingress/egress  - creating separate SG for the VM
#  Ingress: ssh, http, httpS
#  Egress: outbound traffic to all WWW
################################################


module "web_server_sg_http" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "web-server-http"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "web_server_sg_https" {
  source = "terraform-aws-modules/security-group/aws//modules/https-443"

  name        = "web-server-https"
  description = "Security group for web-server with HTTPS ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "vote_service_sg_ingress" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "custom-rules_ingress"
  description = "Security group for user-service with SSH ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "User-service ports-ssh"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "vote_service_sg_egress" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "custom-rules_egress"
  description = "Security group for user-service with OUTBOUND www open within VPC, and PostgreSQL publicly open"
  vpc_id      = module.vpc.vpc_id
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "outbound - User-service ports (ipv4)"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

data "aws_instance" "instance" {
  instance_id = module.ec2.ec2_instance_id
}

resource "aws_network_interface_sg_attachment" "sg_attachment_http" {
  security_group_id    = module.web_server_sg_http.security_group_id
  network_interface_id = data.aws_instance.instance.network_interface_id
}

resource "aws_network_interface_sg_attachment" "sg_attachment_https" {
  security_group_id    = module.web_server_sg_https.security_group_id
  network_interface_id = data.aws_instance.instance.network_interface_id
}

resource "aws_network_interface_sg_attachment" "sg_attachment_ssh" {
  security_group_id    = module.vote_service_sg_ingress.security_group_id
  network_interface_id = data.aws_instance.instance.network_interface_id
}

resource "aws_network_interface_sg_attachment" "sg_attachment_www_egress" {
  security_group_id    = module.vote_service_sg_egress.security_group_id
  network_interface_id = data.aws_instance.instance.network_interface_id
}