run "deployment_account" {
  command = plan

  plan_options {
    refresh = false
  }

  assert {
    condition     = (var.environment == "dev" && data.aws_caller_identity.current.account_id == "954976300695") ? true : (var.environment == "prod" && data.aws_caller_identity.current.account_id == "112233445566") ? true : false
    error_message = "Dev must be deployed to the 954976300695 account!"
  }

  expect_failures = [
    check.grafana_health_check
  ]
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

  expect_failures = [
    check.grafana_health_check
  ]
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

  expect_failures = [
    check.grafana_health_check
  ]
}
