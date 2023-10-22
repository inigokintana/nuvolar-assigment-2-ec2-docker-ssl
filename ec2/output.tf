output "ec2_vm_private_ip" {
  value       = "${module.ec2.private_ip}"
  description = "PrivateIP address details"
}
output "ec2_vm_public_ip" {
  value       = "${module.ec2.public_ip}"
  description = "PublicIP address details"
}
