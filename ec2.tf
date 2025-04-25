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

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEeEFCZrFcB7JdtOwtvBpqayPXZ+Bcwc6D0R30y1NP1w l.harsha7658@gmail.com"
}