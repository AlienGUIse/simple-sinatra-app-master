output "ecr_url" {
  value = aws_ecr_repository.simple-sinatra.repository_url
}

output "ecr_name" {
  value = aws_ecr_repository.simple-sinatra.name
}