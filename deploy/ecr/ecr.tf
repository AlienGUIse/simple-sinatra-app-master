resource "aws_ecr_repository" "simple-sinatra" {
  name = "simple-sinatra"
}

data "template_file" "lifecycle_json" {
  template = file("lifecycle.json")
}

resource "aws_ecr_lifecycle_policy" "ecr_delete_old_images" {
  repository = aws_ecr_repository.simple-sinatra.name
  policy     = data.template_file.lifecycle_json.rendered
}
