#!/bin/bash
#update ubuntu
sudo apt-get update 
# # set FQDN  <- var.ec2_vm_name+var.ec2_fqdn
echo "Changing Hostname"
# This variables come from Terraform variables.tf
sed -e "${var.ec2_vm_name}"."${var.ec2_fqdn}" /etc/hostname <- review
sudo hostname -F /etc/hostname
echo "127.0.0.1 localhost  docker-vm.ikz.com dashboard.ikz.com api-gateway.ikz.com order-api.ikz.com  customer-service.ikz.com" >> /etc/hosts
# # install docker - see https://docs.docker.com/engine/install/ubuntu/
# ## Add Docker's official GPG key:
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# ## Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose -y
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo systemctl status docker.service
sudo systemctl status containerd.service
# # Install traefik using self-signed certificate
# ## traefik network
sudo  docker network create traefik
chmod 600 acme.json
traefik export
export PRIMARY_DOMAIN=yourdomain.de <- var.ec2_fqdn Terraform
export TRAEFIK_SSLEMAIL=email@yourdomain.de  <- var.ec2_fqdn Terraform
#cp docker-compose.yml *into /home/ubuntu/docker-scripts***
docker-compose up -d
# # install curl
sudo apt-get install curl -y
# # ssh RSA public from selected user <-- ec2_user_public_rsa
echo "${var.ec2_user_public_rsa}" >> /home/ubuntu/.ssh/authorized_keys
