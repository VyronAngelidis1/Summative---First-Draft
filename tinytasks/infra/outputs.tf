output "role_arn_for_github_actions" {
  value = aws_iam_role.gha_oidc.arn
}
