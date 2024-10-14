resource "aws_security_group" "gitops_sg" {
  name        = "gitops_sg"
  description = "Allow port 3000"
  vpc_id      = aws_vpc.gitops_vpc.id

  tags = {
    Name = "gitops-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "gitops_sg_ingress_rule" {
  security_group_id = aws_security_group.gitops_sg.id
  from_port         = 3000
  to_port           = 3000
  ip_protocol       = "tcp"
  cidr_ipv4         = ["0.0.0.0/0"]

  tags = {
    Name = "gitops-sg-ingress"
  }
}

resource "aws_vpc_security_group_ingress_rule" "gitops_sg_egress_rule" {
  security_group_id = aws_security_group.gitops_sg.id

  ip_protocol = "-1"
  cidr_ipv4   = ["0.0.0.0/0"]

  tags = {
    Name = "gitops-sg-egress"
  }
}
