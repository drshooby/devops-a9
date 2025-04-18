packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# Update these as needed, current configuration is for lab users
variable "ami_name" {
  default = "custom-ubuntu-ami-{{timestamp}}"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "ssh_key_name" {
  default = "vockey"
}

variable "ssh_pkey_file" {
  default = "~/.ssh/labsuser.pem"
}

# Run echo $HOME/.ssh/labsuser.pub to get the public key path
variable "ssh_public_key_path" {
  default = "/Users/David/.ssh/labsuser.pub"
}

source "amazon-ebs" "ubuntu" {
  ami_name            = var.ami_name
  instance_type       = var.instance_type
  region              = var.aws_region

  ssh_keypair_name    = var.ssh_key_name
  ssh_private_key_file = var.ssh_pkey_file

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners            = ["099720109477"]
    most_recent       = true
  }
  ssh_username        = "ubuntu"
}

build {
  sources = ["source.amazon-ebs.ubuntu"]

  # or apt-get
  provisioner "shell" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",  # prevent interactive prompts
      "sudo apt update -y",
      "sudo apt install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg",
      "echo \"deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
      "sudo apt update -y",
      "sudo apt install -y docker-ce",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo usermod -aG docker ubuntu"
    ]
  }
  
  provisioner "file" {
    source      = var.ssh_public_key_path
    destination = "/tmp/labsuser.pub"
  }
  
  provisioner "shell" {
    inline = [
      "mkdir -p ~/.ssh",
      "chmod 700 ~/.ssh",
      "cat /tmp/labsuser.pub >> ~/.ssh/authorized_keys",
      "chmod 600 ~/.ssh/authorized_keys",
      "rm /tmp/labsuser.pub"
    ]
  }

  provisioner "shell" {
    inline = [
      "echo 'Verifying SSH key setup:'",
      "cat ~/.ssh/authorized_keys",
      "ls -la ~/.ssh",
      "grep -c 'ssh-rsa' ~/.ssh/authorized_keys || echo 'No SSH keys found!'"
    ]
  }
}