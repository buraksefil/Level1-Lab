output "frontend_public_ip" {
  description = "The public IP address of the front-end EC2 instance"
  value       = aws_instance.frontend.public_ip
}