run "deployment_account" {
  command = plan

  plan_options {
    refresh = false
  }

  assert {
    condition     = (var.environment == "dev" && data.aws_caller_identity.current.account_id == "954976300695") ? true : (var.environment == "prod" && data.aws_caller_identity.current.account_id == "816069156152") ? true : false
    error_message = "Dev must be deployed to the 954976300695 account! Prod must be deployed to the 816069156152 account!"
  }

  expect_failures = [
    check.grafana_health_check
  ]
}
