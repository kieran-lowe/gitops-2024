terraform {
  required_version = ">= 1.8.3, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, < 6.0.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 3.0.0, < 4.0.0"
    }
  }

  backend "s3" {
    bucket         = "mtc-gitops2024-terraform-state-a12b"
    encrypt        = true
    kms_key_id     = "arn:aws:kms:eu-west-2:195275655961:key/77235df8-1d9e-4340-af90-e95a615ce943"
    region         = "eu-west-2"
    dynamodb_table = "mtc-gitops2024-terraform-state-locks-a12b"
    assume_role_with_web_identity = {
      role_arn                = "arn:aws:iam::195275655961:role/mtc-gitops2024-terraform-state-role"
      session_name            = "mtc-gitops2024-state-access"
      web_identity_token_file = "/tmp/web-identity-token"
      duration                = "15m"
    }
  }
}

provider "aws" {
  region = var.region

  assume_role_with_web_identity {
    role_arn                = "arn:aws:iam::954976300695:role/mtc-gitops2024-terraform-dev-deployment-role"
    session_name            = "mtc-gitops2024-ghactions-deployment"
    web_identity_token_file = "/tmp/web-identity-token"
    duration                = "15m"
  }

  default_tags {
    tags = {
      Project     = "MoreThanCertified"
      Environment = var.environment
    }
  }
}
