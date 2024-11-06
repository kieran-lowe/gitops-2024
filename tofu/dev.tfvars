environment   = "dev"
region        = "eu-west-2"
instance_name = "grafana-server"
instance_type = "t3.micro"
volume_size   = 8
additional_tags = {
  purpose = "monitoring"
}