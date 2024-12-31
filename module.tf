# Variables
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_name" {}
variable "private_key_path" {}


# Provider
provider "aws" {
  region  = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
provider "aws" {
  region  = "us-west-2"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}



# DATA
data "aws_ami" "aws_ubuntu" {
  most_recent = true
  owners      = ["amazon"]

 filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


# RESOURCES
# Ami

resource "aws_instance" "instance_us_east"{
  instance_type          = "t2.micro"
  ami                    = "ami-0e2c8caa4b6378d8c"
  key_name               = "test"
  user_data              = file("userdata.tpl")
}  
resource "aws_instance" "instance_us_west"{
  instance_type          = "t2.micro"
  ami                    = "ami-2c8caa4b6378d8c"
  key_name               = "guvi"
  user_data              = file("userdata.tpl")
}  


# Default VPC
resource "aws_default_vpc" "default" {

}

# Security group
resource "aws_security_group" "demo_sg" {
  name        = "demo_sg"
  description = "allow ssh on 22 & http on port 80"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}



# OUTPUT
output "aws_instance_public_dns" {
  value = aws_instance.aws_ubuntu.public_dns
}

