# tflint-ignore: terraform_unused_declarations
data "aws_caller_identity" "current" {}

# data "aws_partition" "current" {}
data "aws_region" "current" {}
# data "aws_default_tags" "tags" {}
# data "aws_iam_session_context" "current" {
#   arn = data.aws_caller_identity.current
# }

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

