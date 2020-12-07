resource "aws_ecr_repository" "simple-sinatra" {
  name = "simple-sinatra"
}

data "template_file" "lifecycle_json" {
  template = file("config/lifecycle.json")
}

resource "aws_ecr_lifecycle_policy" "ecr_delete_old_images" {
  repository = aws_ecr_repository.simple-sinatra.name
  policy     = data.template_file.lifecycle_json.rendered
}

data "template_file" "permissions_json" {
  template = file("config/permissions.json")
}

resource "aws_ecr_repository_policy" "allow_access" {
  repository = aws_ecr_repository.simple-sinatra.name
  policy     = data.template_file.permissions_json.rendered
}