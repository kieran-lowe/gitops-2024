run "instance_name_check" {
  variables {
    instances = {
      "grafana_server" = {
        instance_type = "t3.micro"
        volume_size   = 10
        additional_tags = {
          Purpose = "Monitoring"
        }
      }
    }
  }

  expect_failures = [ var.instances ]

  command = plan
}

