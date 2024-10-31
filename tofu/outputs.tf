output "grafana_ips" {
  value       = { for key, value in aws_instance.grafana_server : key => "http://${value.public_ip}:3000" }
  description = "URL to access the Grafana server"
}
