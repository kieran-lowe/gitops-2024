output "grafana_ip" {
  value       = "http://${aws_instance.grafana_server.public_ip}:3000"
  description = "URL to access the Grafana server"
}

output "region" {
  value       = data.aws_region.current.name
  description = "Name of the region used for deployment"
}

output "account_id" {
  value       = data.aws_caller_identity.current.account_id
  description = "AWS Account ID used for deployment"
}
