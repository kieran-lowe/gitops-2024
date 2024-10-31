environment = "dev"
region      = "eu-west-2"
instances = {
  "grafana-server" = {
    instance_type = "t3.micro"
    volume_size   = 1000
    additional_tags = {
      Purpose = "Monitoring"
    }
  }
}
