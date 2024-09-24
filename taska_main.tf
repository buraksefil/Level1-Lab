provider "aws" {
  region = "us-east-1"
}

# Security Group for EC2 Instance
resource "aws_security_group" "frontend_sg" {
  name   = "frontend_sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
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

  tags = {
    Name = "frontend_sg"
  }
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get default Security Group
data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name = "default"
}

# Get default subnets
data "aws_subnets" "default" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# EC2 Instance
resource "aws_instance" "frontend" {
  ami                         = "ami-0ebfd941bbafe70c6"  # Amazon Linux 2 AMI
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = data.aws_subnets.default.ids[0]
  security_groups             = [data.aws_security_group.default.id]

  tags = {
    Name = "frontend_instance"
  }
}

# Define region for AWS provider 
variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "us-east-1"
}

output "frontend_public_ip" {
  description = "The public IP address of the front-end EC2 instance"
  value       = aws_instance.frontend.public_ip
}