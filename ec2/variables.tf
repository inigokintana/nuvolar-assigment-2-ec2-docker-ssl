variable "ec2_ami_id" {
  type = string
  # ask permission to access this private image on 733109890878 account id in eu-west-1
}


variable "ec2_vm_name" {
  type    = string
}

variable "ec2_fqdn" {
  type    = string
}

variable "ec2_user_public_rsa" {
  type    = string
}

variable "ec2_instance_type" {
  type    = string
}

variable "ec2_key_name" {
  type = string
}

variable "ec2_subnet_id" {
  type = string
}