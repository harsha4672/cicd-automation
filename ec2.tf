terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# create instance
resource "aws_instance" "first-tf-instance" {
  
  instance_type          = "t2.micro"
  key_name               = "deployer-key"
  monitoring             = true
  ami = "ami-084568db4383264d4"
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install fontconfig openjdk-21-jre -y
              sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
              https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
              echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
                https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
                /etc/apt/sources.list.d/jenkins.list > /dev/null
              sudo apt-get update -y
              sudo apt-get install jenkins -y
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              sudo systemctl status jenkins
  EOF

  security_groups = ["${aws_security_group.ssh_access.id}"]

  subnet_id = "subnet-021f92fe5febe9d12"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}

resource "aws_security_group" "ssh_access" {
  name        = "ssh_access"
  description = "SG module"
  vpc_id = "vpc-0127b1e28e479d847"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEeEFCZrFcB7JdtOwtvBpqayPXZ+Bcwc6D0R30y1NP1w l.harsha7658@gmail.com"
}