
################################################################################
# Default Variables
################################################################################

variable "profile" {
  type    = string
  default = "default"
}

variable "main-region" {
  type    = string
  default = "eu-west-1"
}


################################################################################
# VPC  Variables
################################################################################
variable  "vpc_name" {
  type = string
  default = "ec2-vpc"
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_azs" {
  type = list
  default =  ["eu-west-1a", "eu-west-1b","eu-west-1c"]
}

variable "vpc_private_subnets" {
  type = list 
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "vpc_public_subnets" {
  type = list
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "vpc_nat_gateway"{  
  type = bool
  default = true
}

################################################################################
# ec2 Variables
################################################################################
variable "ec2_ami_id" {
  type = string
  #  please send me your AWS account id to share access  to this private image on  my AWS 733109890878 account id in eu-west-1
  default = "ami-02612f41537049892" 
}

variable "ec2_vm_name" {
  type    = string
  default = "docker-vm"
}

variable "ec2_fqdn" {
  type    = string
  default = "ikz.com"
}

variable "ec2_user_public_rsa" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXb9tU+H1UmWfq3v1WczI64CZG8lBFgBpWpK3LOsXqsCtYg8h/Udp0DiCq+2EtuR0NwhVX6iweezamE7TOVXMgBGVxS7Y6IjmoVqln8WJHzMEG+kpBhV75LrmJxpEPRzE5EcdwgmQcTs1wlHsA845BzF0ii19s6BfSDSqnywgTLQXtG8E3BnTaVayWOJ/BuOtTdUUNewsUFAdOexHASvkrC7jDClEOqdK4El7VAb0WF39Cckawz9wHOk/CaqMrFsI2+aiTIjcMF4atw+vrJGwtyRNy5N0m2o+fSCeY8A7NXUPgy1dUMcs7CEJKxeUV3L6ogJJxQT9wvaaw4JibJF51U0AxNLJFr6jeNmM0nJOlZ4aDjW2Jat89wVA+tov67W0iN4AR8QU7MtbQOSixGmMr+Xya6bHoSTmv6BMvDNrvGtWXcd8+OzLwR+1hfI+oGqbLrnf/Al22TOB9NFR6Z7oGH987NaJozj5U0Ndj/JKYQXUTAmfGfAMUlSVVhJbnYcZkYx1iJXu3ToJRecTxgEA7+ewqvnkb102/8c5Mf7D8A5xylTAgvvxlWeGiMLBWv6i30DI5P0NuP2ict/29XqskU/xdFr0QCAq+tne/P1fNaiD0r7MDtslVpXsPKj7oTzJWHfRKNsrjLiu05GeIQkwLEykXTSFjwdRXrBxR9Mi2PQ== inigokintana@DESKTOP-41AHSCB"
}
 
variable "ec2_instance_type" {
  type = string
  default = "t3a.medium"
}

variable "ec2_key_name" {
  type = string
  default = "tf-user"
}

variable "ec2_subnet_id" {
  type = string
  default ="none"
}