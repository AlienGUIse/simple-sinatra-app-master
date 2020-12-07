output "ecr_url" {
  value = var.ECR_URL
}

output "current_build" {
  value = var.BUILD_NUMBER
}

output "public_ip" {
  value = aws_instance.ec2_instance.public_ip
}