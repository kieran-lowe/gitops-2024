
environment = "dev"
instances = {
  "grafana-server" = {
    instance_type = "t3.micro"
    volume_size   = 10
    additional_tags = {
      Purpose = "Monitoring"
    }
  }
}
