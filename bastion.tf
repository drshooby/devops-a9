resource "aws_key_pair" "bastion-key" {
  key_name   = var.ssh_key_name
  public_key = file(var.public_key)
}

module "bastion" {
  source  = "cloudposse/ec2-bastion-server/aws"
  version = "0.31.1"

  vpc_id                      = module.vpc.vpc_id
  subnets                     = module.vpc.public_subnets
  key_name                    = var.ssh_key_name
  instance_profile             = var.iam_instance_profile
  security_group_rules        = [
    {
      "cidr_blocks": var.bastion_allowed_cidr,
      "description": "Allow SSH from specific networks",
      "from_port": 22,
      "protocol": "tcp",
      "to_port": 22,
      "type": "ingress",
      "name": "ssh from my ip"
    },
    {
      "cidr_blocks": ["0.0.0.0/0"],
      "description": "Allow all outbound traffic",
      "from_port": 0,
      "protocol": -1,
      "to_port": 0,
      "type": "egress",
      "name": "allow all outbound"
    }
  ]
  ssh_user                    = "ec2-user"
  name                        = var.bastion_name
  associate_public_ip_address = true
  tags                        = var.resource_tags
}