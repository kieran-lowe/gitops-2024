terraform {
  required_version = ">= 1.8.3, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, < 6.0.0"
    }
  }
}

provider "aws" {
  region = var.region

  assume_role_with_web_identity {
    role_arn                = "arn:aws:iam::123456789012:role/role-name"
    session_name            = "session-name"
    web_identity_token_file = "/path/to/token"
  }

  default_tags {
    tags = {
      Project     = "MoreThanCertified"
      Environment = var.environment
    }
  }
}
