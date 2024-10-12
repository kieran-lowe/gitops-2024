data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_default_tags" "tags" {}
data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current
}
