output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "web_url" {
  description = "URL to access the web app"
  value       = "http://${aws_instance.web.public_ip}"
}
