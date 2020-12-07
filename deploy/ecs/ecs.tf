#-------IAM Role and Policy--------
data "template_file" "iam_policy_json" {
  template = file("iam_policy.json")
}

resource "aws_iam_role_policy" "simple_sinatra_iam_policy" {
  name   = "simple_sinatra_iam_policy"
  role   = aws_iam_role.simple_sinatra_iam_role.name
  policy = data.template_file.iam_policy_json.rendered
}

data "template_file" "iam_role_json" {
  template = file("iam_role.json")
}

resource "aws_iam_role" "simple_sinatra_iam_role" {
  name               = "simple_sinatra_iam_role"
  assume_role_policy = data.template_file.iam_role_json.rendered
}

resource "aws_iam_role_policy_attachment" "ecs_task_permissions" {
  role       = aws_iam_role.simple_sinatra_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}



#------Create task defination------

data "template_file" "task_definition" {
  template = file("service.json")

  vars = {
    REPOSITORY_URL        = var.ECR_URL
    BUILD_NUMBER          = var.BUILD_NUMBER
  }
}

resource "aws_ecs_task_definition" "service_td" {
  family                   = "simple-sinatra"
  container_definitions    = data.template_file.task_definition.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.simple_sinatra_iam_role.arn
}

resource "aws_ecs_service" "simple-sinatra" {
  name                              = "simple-sinatra"
  cluster                           = "simple-sinatra"
  launch_type                       = "FARGATE"
  task_definition                   = aws_ecs_task_definition.service_td.arn
  desired_count                     = 1


  network_configuration {
    subnets = ["subnet-4844df10"]
    assign_public_ip = true
    security_groups  = [aws_security_group.simple_sinatra_sg.id]
  }
}

resource "aws_security_group" "simple_sinatra_sg" {
  name        = "simple_sinatra_sg"
  vpc_id      = "vpc-c57b7ba2"

  ingress {
    from_port       = 4002
    to_port         = 4002
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
