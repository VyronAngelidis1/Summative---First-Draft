resource "aws_ecr_repository" "app" {
  name = var.app_name
  image_scanning_configuration { scan_on_push = true }
}
output "ecr_url" { value = aws_ecr_repository.app.repository_url }
