variable "aws_region" { type = string }
variable "app_name"  { type = string }
variable "image_tag" { type = string }
variable "github_org" { type = string }
variable "github_repo" { type = string }
variable "github_oidc_provider_arn" {
  type = string
  default = "arn:aws:iam::<YOUR_AWS_ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
}
