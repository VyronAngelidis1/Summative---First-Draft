data "aws_iam_openid_connect_provider" "github" {
  arn = var.github_oidc_provider_arn
}

resource "aws_iam_role" "gha_oidc" {
  name = "${var.app_name}-gha-oidc"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "sts:AssumeRoleWithWebIdentity",
      Principal = { Federated = data.aws_iam_openid_connect_provider.github.arn },
      Condition = {
        StringEquals = { "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com" },
        StringLike = { "token.actions.githubusercontent.com:sub" : "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/*" }
      }
    }]
  })
}

resource "aws_iam_policy" "gha_policy" {
  name = "${var.app_name}-gha-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "ecr:*",
        "apprunner:*",
        "iam:PassRole",
        "logs:*",
        "cloudwatch:*"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "gha_attach" {
  role       = aws_iam_role.gha_oidc.name
  policy_arn = aws_iam_policy.gha_policy.arn
}
