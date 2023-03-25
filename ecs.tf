#--------------------------------------------------------------------------------------------------
# ECS Cluster
#--------------------------------------------------------------------------------------------------
resource "aws_ecs_cluster" "agents" {
  name = "${var.friendly_name_prefix}-cloud-agents-cluster"

  tags = merge(
    { "Name" = "${var.friendly_name_prefix}-cloud-agents-cluster" },
    var.common_tags
  )
}

#--------------------------------------------------------------------------------------------------
# ECS Service
#--------------------------------------------------------------------------------------------------
resource "aws_ecs_service" "agents" {
  name                = "${var.friendly_name_prefix}-cloud-agents-service"
  cluster             = aws_ecs_cluster.agents.id
  task_definition     = aws_ecs_task_definition.agents.arn
  desired_count       = var.number_of_agents
  launch_type         = "FARGATE"
  platform_version    = "LATEST"
  scheduling_strategy = "REPLICA"
  propagate_tags      = "SERVICE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [aws_security_group.agents.id]
    assign_public_ip = var.assign_public_ip
  }

  tags = merge(
    { "Name" = "${var.friendly_name_prefix}-cloud-agents-service" },
    { "ECS_Launch_Type" = "Fargate" },
    var.common_tags
  )
}

#--------------------------------------------------------------------------------------------------
# ECS Task Definition
#--------------------------------------------------------------------------------------------------
resource "aws_ecs_task_definition" "agents" {
  family                   = "${var.friendly_name_prefix}-cloud-agents-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name   = "tfc-agent"
      image  = var.agent_image
      cpu    = var.cpu
      memory = var.memory
      logConfiguration : {
        logDriver : "awslogs",
        options : {
          awslogs-group : "${var.friendly_name_prefix}-tfe-agents-ecs",
          awslogs-region : "${var.region}",
          awslogs-stream-prefix : var.friendly_name_prefix
        }
      }
      essential = true
      environment = [
        {
          name  = "TFC_AGENT_NAME",
          value = var.tfc_agent_name
        },
        {
          name  = "TFC_AGENT_TOKEN",
          value = var.tfc_agent_token
        },
        {
          name  = "TFC_ADDRESS",
          value = var.tfc_address
        },
        {
          name  = "AGENT_LOG_LEVEL",
          value = var.agent_log_level
        }
      ]
    }
  ])
}