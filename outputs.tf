# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# AZs
output "azs" {
  description = "A list of availability zones spefified as argument to this module"
  value       = module.vpc.azs
}

# Security Group
output "sg_id" {
  value = module.bastion.security_group_id
}

# Bastion Public IP for SSH
output "bastion_public_ip" {
  value = module.bastion.public_ip
}

# Bastion SSH User, also for SSH
output "bastion_ssh_user" {
  value = module.bastion.ssh_user
}

# Bastion Private IP
output "bastion_private_ip" {
  value = module.bastion.private_ip
}

# EC2 Instance Details
output "ec2_instance_details" {
  value = {
    for name, instance in aws_instance.machines : 
      name => {
        id = instance.id
        private_ip = instance.private_ip
      }
  }
}