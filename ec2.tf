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
  key_name               = "user1"
  monitoring             = true
  ami = "ami-084568db4383264d4"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}