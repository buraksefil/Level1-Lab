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
  ami                         = "ami-0e86e20dae9224db8"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = data.aws_subnets.default.ids[0]
  security_groups             = [aws_security_group.frontend_sg.id]
  key_name = "id_rsa"

provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/Downloads/id_rsa.pem")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "frontend_instance"
  }
}

# Define region for AWS provider 
variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "us-east-1"
}

