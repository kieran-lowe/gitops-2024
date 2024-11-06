deployment_role_arn = "arn:aws:iam::816069156152:role/mtc-gitops2024-terraform-prod-deployment-role"
role_session_name   = "mtc-gitops2024-ghactions-deployment-prod"

environment   = "prod"
region        = "eu-west-2"
instance_name = "grafana-server"
instance_type = "t3.micro"
volume_size   = 8
additional_tags = {
  purpose = "monitoring"
  tool    = "grafana"
}
