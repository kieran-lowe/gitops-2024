tflint {
  required_version = ">= 0.50"
}

config {
  format           = "json"
  call_module_type = "all"
}

plugin "terraform" {
  enabled = true
}

plugin "aws" {
  enabled = true
  version = "0.33.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

plugin "terraform" {
  enabled = true
  version = "0.9.1"
  source  = "github.com/terraform-linters/tflint-ruleset-terraform"
  preset  = "all"
}
