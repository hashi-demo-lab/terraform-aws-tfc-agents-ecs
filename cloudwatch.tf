resource "aws_cloudwatch_log_group" "tfe_agents_ecs" {
  count = var.enable_logs == true ? 1 : 0

  name = "${var.friendly_name_prefix}-tfe-agents-ecs"

  tags = merge(
    { "Name" = "${var.friendly_name_prefix}-tfe-agents-ecs-logs" },
    var.common_tags
  )
}