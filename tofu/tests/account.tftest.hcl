run "is_dev_account" {
  command = plan

  plan_options {
    refresh = false
  }

  assert {
    condition     = var.environment == "dev" && data.aws_caller_identity.current.account_id == "954976300695"
    error_message = "Dev must be deployed to the 954976300695 account!"
  }
}

run "is_prod_account" {
  command = plan

  plan_options {
    refresh = false
  }

  assert {
    condition     = var.environment == "prod" && data.aws_caller_identity.current.account_id == "112233445566"
    error_message = "Prod must be deployed to the 112233445566 account!"
  }
}

run "dev_override" {
  command = plan

  plan_options {
    refresh = false
  }

  variables {
    environment = "dev"
  }

  assert {
    condition     = data.aws_caller_identity.current.account_id != "954976300695" ? false : true
    error_message = "Dev must be deployed to the 954976300695 account!"
  }
}

run "prod_override" {
  command = plan

  plan_options {
    refresh = false
  }

  variables {
    environment = "prod"
  }

  assert {
    condition     = data.aws_caller_identity.current.account_id != "954976300695" ? false : true
    error_message = "Prod must be deployed to the 954976300695 account!"
  }
}
