run "region_input" {
  assert {
    condition     = data.aws_region.current.name != "eu-west-2" ? false : true
    error_message = "The only allowed region is eu-west-2!"
  }

  assert {
    condition     = var.region == "eu-west-2" ? true : false
    error_message = "The only allowed region is eu-west-2!"
  }

  command = plan

  expect_failures = [
    check.grafana_health_check
  ]
}
