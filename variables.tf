#--------------------------------------------------------------------------------------------------
# Common
#--------------------------------------------------------------------------------------------------
variable "friendly_name_prefix" {
  type        = string
  description = "Friendly name to prefix AWS resource names with."
}

variable "common_tags" {
  type        = map(string)
  description = "Map of common tags for taggable AWS resources."
  default     = {}
}

variable "region" {
  type        = string
  description = "The AWS Region to deploy resources into."
  default     = "us-east-1"
}

#--------------------------------------------------------------------------------------------------
# Networking
#--------------------------------------------------------------------------------------------------
variable "vpc_id" {
  type        = string
  description = "VPC ID for Security Group and ECS Service."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of Subnet IDs to use for ECS tasks or services. Format should be a list of strings. Example ['subnet1', 'subnet2']"
}

#--------------------------------------------------------------------------------------------------
# Cloud Agents
#--------------------------------------------------------------------------------------------------
variable "tfc_agent_token" {
  type        = string
  description = "Agent pool token to authenticate to TFC/TFE when cloud agents are instantiated."
}

variable "tfc_agent_name" {
  type        = string
  description = "The name of the agent."
  default     = "ecs-agent"
}

variable "tfc_agent_version" {
  type        = string
  description = "Version of tfc-agent to run."
  default     = "1.2.0"
}

variable "tfc_address" {
  type        = string
  description = "Hostname of self-hosted TFE instance. Leave default if TFC is in use."
  default     = "https://app.terraform.io"
}

variable "number_of_agents" {
  type        = number
  description = "Number of cloud agents to run per instance."
  default     = 1
}

variable "assign_public_ip" {
  type        = bool
  description = "Only required when using Fargate for ECS services placed in public subnets. Needed for fargate to assign ENI and pull docker image. True or False"
  default     = "false"
}

variable "agent_image" {
  type        = string
  description = "The registry/image:tag_Version to use for the agent. Default = hashicorp/tfc-agent:latest"
  default     = "hashicorp/tfc-agent:latest"
}

variable "agent_log_level" {
  type        = string
  description = "The log verbosity. Level options include 'trace', 'debug', 'info', 'warn', and 'error'. Log levels have a progressive level of data sensitivy. The 'info', 'warn', and 'error' levels are considered generally safe for log collection and don't include sensitive information. The 'debug' log level may include internal system details, such as specific commands and arguments including paths to user data on the local filesystem. The 'trace' log level is the most sensitive and may include personally identifiable information, secrets, pre-authorized internal URLs, and other sensitive material."
  default     = "info"
}

variable "enable_logs" {
  type        = bool
  description = "Whether or not to enable tfc-agent ECS logs."
  default     = true
}

variable "cpu" {
  type        = number
  description = "Number of cpu units used by the task. If the requires_compatibilities is FARGATE this field is required."
  default     = 1024
}

variable "memory" {
  type        = number
  description = "Amount (in MiB) of memory used by the task. If the requires_compatibilities is FARGATE this field is required."
  default     = 2048
}