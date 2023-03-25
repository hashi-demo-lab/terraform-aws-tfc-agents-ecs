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