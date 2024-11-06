run "instance_name_invalid_check" {
  variables {
    instance_name = "Grafana-Server"
  }

  expect_failures = [var.instance_name]

  command = plan
}

run "instance_name_valid_check" {
  assert {
    condition     = can(regex("^[a-z0-9-]+$", var.instance_name))
    error_message = "${format("%#v", var.instance_name)} is not a valid instance name. Ensure your instance name is alphanumeric and lowercase!"
  }

  command = plan

  expect_failures = [
    check.grafana_health_check
  ]
}
