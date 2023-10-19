
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
  ami = "ami-0a66cb7af2a5a4c9c" # <- ami-0e3c6fef26e181c1d
#  ami = data.aws_ami_ids.ubuntu
  #vpc_security_group_ids = module.vpc.
  subnet_id              = var.ec2_subnet_id

  #user_data = "${file("vm_docker_config.sh")}"
#   user_data = <<EOF
# #!/bin/bash
# #update ubuntu
# sudo apt-get update
# # set FQDN  <- var.ec2_vm_name+var.ec2_fqdn
# echo "Changing Hostname"
# sed -e "${var.ec2_vm_name}"."${var.ec2_fqdn}" /etc/hostname <- review
# sudo hostname -F /etc/hostname
# # create self-signed certificate <- var.ec2_vm_name+var.ec2_fqdn
# # install docker - see https://docs.docker.com/engine/install/ubuntu/
# ## Add Docker's official GPG key:
# sudo apt-get install ca-certificates curl gnupg -y
# sudo install -m 0755 -d /etc/apt/keyrings
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# sudo chmod a+r /etc/apt/keyrings/docker.gpg

# ## Add the repository to Apt sources:
# echo \
#   "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
#   "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
#   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# sudo apt-get update
# sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y
# sudo systemctl enable docker.service
# sudo systemctl enable containerd.service
# sudo systemctl status docker.service
# sudo systemctl status containerd.service
# # Install traefik using self-signed certificate
# ## traefik network
# sudo  docker network create traefik
# sudo apt-get install apache2-utils
# sudo htpasswd -nb admin secure_password > /tmp/admin
# ## traefik listens on 80 (http port) and 8080 (web ui)
# sudo docker-compose -f ./docker-compose/docker-componse-traefik.yml up -d
# sudo docker-compose -f ./docker-compose/docker-compose-whoami.yml up -d
# # install nuvolar-works docker
# https://hub.docker.com/r/nuvolar/api-gateway - 8080
# docker run -p 8080:8080 -t nuvolar/api-gateway -e ORDER_SERVICE_URL=XXXX
# https://stackoverflow.com/questions/55003036/accesing-another-service-using-its-url-from-inside-the-docker-compose-network
# service-api:
#     environment: 
#       - SERVER_URL=http://service-b:8080/myserver

#       networks:
#       - internal
#       - traefik
# https://hub.docker.com/r/nuvolar/order-service - 8081
# docker run -p 8081:8080 --name order-service -e CUSTOMER_SERVICE_URL=XXXXX -t nuvolar/order-service
# networks:
#       - internal
# https://hub.docker.com/r/nuvolar/customer-service - 8082
# docker run -p 8082:8080 --name customer-service -t nuvolar/customer-service
# networks:
#       - internal
# # change /etc/hosts
# sed -e 's/localhost/localhost inigo/g' /etc/hosts
# # install curl
# sudo apt-get install curl -y
# # curl from inside VM - no verify certificate
# curl http://
# curl -k https://
# # ssh RSA public from selected user <-- ec2_user_public_rsa
# echo "${var.ec2_user_public_rsa}" >> /home/ubuntu/.ssh/authorized_keys
# EOF
  tags = {
    Terraform   = "true"
    Environment = "dev"
}
}


output "ec2_vm_private_ip" {
  value       = "${module.ec2.private_ip}"
  description = "PrivateIP address details"
}
output "ec2_vm_public_ip" {
  value       = "${module.ec2.public_ip}"
  description = "PublicIP address details"
}

