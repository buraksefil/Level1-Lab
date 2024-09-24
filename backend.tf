
# EC2 Instance
resource "aws_instance" "backend" {
  ami                         = "ami-0e86e20dae9224db8" 
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  subnet_id                   = data.aws_subnets.default.ids[0]
  security_groups             = [aws_security_group.backend_sg.id]
  key_name                    = "id_rsa"
}

# Security Group for EC2 Instance
resource "aws_security_group" "backend_sg" {
  name   = "backend_sg"
  vpc_id = data.aws_vpc.default.id
  

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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
    Name = "backend_sg"
  }
}