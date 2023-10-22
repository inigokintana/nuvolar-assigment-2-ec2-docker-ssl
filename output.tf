################################################################################
# EC2 VM
################################################################################

output "ec2_vm_private_ip" {
  value       = "${module.ec2.private_ip}"
  description = "PrivateIP address details"
}
output "ec2_vm_public_ip" {
  value       = "${module.ec2.public_ip}"
  description = "PublicIP address details"
}

################################################################################
# VPC
################################################################################

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

