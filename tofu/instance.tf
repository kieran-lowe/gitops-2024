
resource "aws_instance" "grafana_server" {
  #checkov:skip=CKV2_AWS_41:Instance profile not required

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.gitops_subnet.id
  vpc_security_group_ids = [aws_security_group.gitops_sg.id]
  user_data              = templatefile("${path.module}/scripts/userdata.tftpl", {})

  ebs_optimized = true

  #checkov:skip=CKV_AWS_126:Keeping costs low by staying in the free tier
  monitoring = false
  tags = {
    Name = "grafana-server"
  }

  root_block_device {
    volume_size = 10
    encrypted   = true
    tags = {
      Name = "grafana-server-root-volume"
    }
  }

  # Enforce IMDSv2
  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    http_endpoint               = "enabled"
  }
}
