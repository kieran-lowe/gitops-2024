provider "aws" {
  region = "eu-west-1"

  assume_role_with_web_identity {
    role_arn                = "arn:aws:iam::123456789012:role/role-name"
    web_identity_token_file = "/path/to/token"
  }

  default_tags {
    tags = {}
  }
}