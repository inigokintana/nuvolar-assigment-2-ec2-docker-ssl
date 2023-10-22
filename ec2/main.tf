
# get manually created key pair in order to create the ec2 instance
data "aws_key_pair" "tf" {
  key_name = var.ec2_key_name
  filter {
    name   = "tag:Component"
    values = ["terraform"]
  }
}

# get ubuntu 20.04 for AMD 
data "aws_ami_ids" "ubuntu" {
  owners = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["ubuntu/images/ubuntu-20-04-amd64-server-*"]
  }
}

############
# ec2 module
############


module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = var.ec2_vm_name
  instance_type          = var.ec2_instance_type
  key_name               =  data.aws_key_pair.tf.key_name # got above
  monitoring             = false
  associate_public_ip_address = true
  ami                    = var.ec2_ami_id # ask acces to this private AMI
  subnet_id              = var.ec2_subnet_id

  #user_data = "${file("vm_docker_config.sh")}"
  user_data = <<EOF
#!/bin/bash
# #update ubuntu
sudo apt-get update -y
# # set FQDN  <- var.ec2_vm_name+var.ec2_fqdn
echo "Changing Hostname"
#sed -e "${var.ec2_vm_name}"."${var.ec2_fqdn}" /etc/hostname
#sudo hostname -F /etc/hostname
sudo hostnamectl set-hostname ${var.ec2_vm_name}.${var.ec2_fqdn}
# ssh RSA public from selected users <-- ec2_user_public_rsa
echo "${var.ec2_user_public_rsa}" >> /home/ubuntu/.ssh/authorized_keys
EOF
  tags = {
    Terraform   = "true"
    Environment = "dev"
}
}
