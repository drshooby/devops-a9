resource "aws_security_group" "private_instances" {
  name        = "private-instances-sg"
  description = "Security group for private instances"
  vpc_id      = module.vpc.vpc_id
  tags        = var.resource_tags

  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [ module.bastion.security_group_id ]
  }

  # For docker swarm
  # TCP port 2377 for cluster management communications,
  # TCP and UDP port 7946 for communication among nodes,
  # TCP and UDP port 4789 for overlay network traffic.
  ingress {
    description = "Docker swarm"
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    cidr_blocks = [ module.vpc.vpc_cidr_block ]
  }

  ingress {
    description = "Docker swarm"
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    cidr_blocks = [ module.vpc.vpc_cidr_block ]
  }

  ingress {
    description = "Docker swarm"
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    cidr_blocks = [ module.vpc.vpc_cidr_block ]
  }

  ingress {
    description = "Docker swarm"
    from_port   = 4789
    to_port     = 4789
    protocol    = "tcp"
    cidr_blocks = [ module.vpc.vpc_cidr_block ]
  }

  ingress {
    description = "Docker swarm"
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = [ module.vpc.vpc_cidr_block ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "machines" {
  for_each               = var.ec2_instance_names
  ami                    = var.packer_ami_id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.private_subnets[0]
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [ aws_security_group.private_instances.id ]

  tags                   = merge(
    var.resource_tags,
    {
      Name = each.key
    }
  )
}