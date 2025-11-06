resource "aws_iam_role" "apprunner_ecr" {
  name = "${var.app_name}-apprunner-ecr"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "build.apprunner.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "apprunner_ecr_policy" {
  name = "${var.app_name}-apprunner-ecr-policy"
  role = aws_iam_role.apprunner_ecr.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_apprunner_service" "svc" {
  service_name = var.app_name
  source_configuration {
    image_repository {
      image_identifier      = "${aws_ecr_repository.app.repository_url}:${var.image_tag}"
      image_repository_type = "ECR"
      image_configuration {
        port = "8000"
        runtime_environment_variables = {
          LOG_LEVEL = "INFO"
        }
      }
    }
    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_ecr.arn
    }
  }
}
output "apprunner_service_url" {
  value = aws_apprunner_service.svc.service_url
}
