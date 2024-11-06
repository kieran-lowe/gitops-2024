
resource "aws_instance" "grafana_server" {
  #checkov:skip=CKV2_AWS_41:Instance profile not required
  for_each = var.instances

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = each.value.instance_type
  subnet_id              = aws_subnet.gitops_subnet.id
  vpc_security_group_ids = [aws_security_group.gitops_sg.id]
  user_data              = templatefile("${path.module}/scripts/userdata.tftpl", {})
  ebs_optimized          = true

  #checkov:skip=CKV_AWS_126:Keeping costs low by staying in the free tier
  monitoring = coalesce(each.value.enable_detailed_monitoring, false)

  tags = merge(each.value.additional_tags,
    {
      Name = each.key
    }
  )

  root_block_device {
    volume_size = each.value.volume_size
    encrypted   = true

    tags = merge(each.value.additional_tags,
      {
        Name = "${each.key}-root-volume"
      }
    )
  }

  # Enforce IMDSv2
  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    http_endpoint               = "enabled"
  }

  lifecycle {
    precondition {
      condition     = data.aws_region.current.name != var.region ? false : true
      error_message = "Instances can only be deployed in: ${var.region}! Your configuration is set to: ${data.aws_region.current.name}"
    }
  }
}
