resource "aws_security_group" "agents" {
  name   = "${var.friendly_name_prefix}-tfc-cloud-agents-sg"
  vpc_id = var.vpc_id
  tags   = merge({ "Name" = "${var.friendly_name_prefix}-tfc-cloud-agents-sg" }, var.common_tags)
}

resource "aws_security_group_rule" "egress_https" {
  type        = "egress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow HTTPS traffic egress."

  security_group_id = aws_security_group.agents.id
}


resource "aws_security_group_rule" "egress_https_f5" {
  type        = "egress"
  from_port   = 8443
  to_port     = 8443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow HTTPS traffic egress F5."

  security_group_id = aws_security_group.agents.id
}


resource "aws_security_group_rule" "egress_dns_tcp" {
  type        = "egress"
  from_port   = 53
  to_port     = 53
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow HTTPS traffic egress F5."

  security_group_id = aws_security_group.agents.id
}


resource "aws_security_group_rule" "egress_dns_udp" {
  type        = "egress"
  from_port   = 53
  to_port     = 53
  protocol    = "udp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow HTTPS traffic egress F5."

  security_group_id = aws_security_group.agents.id
}


resource "aws_security_group_rule" "egress_vault_tcp" {
  type        = "egress"
  from_port   = 8200
  to_port     = 8200
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Allow Vault traffic egress."

  security_group_id = aws_security_group.agents.id
}