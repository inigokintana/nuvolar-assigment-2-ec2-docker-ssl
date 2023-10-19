################################################################################
# General Variables from root module
################################################################################
variable "profile" {
  type    = string
}

variable "main-region" {
  type    = string
}


## VPC specific variables
variable  "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "vpc_azs" {
  type = list
}

variable "vpc_private_subnets" {
  type = list 
}

variable "vpc_public_subnets" {
  type = list
}

variable "vpc_nat_gateway"{  
  type = bool
}
