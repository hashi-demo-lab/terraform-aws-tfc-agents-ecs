# terraform-aws-tfc-agents-ecs
Terraform module to deploy AWS ECS with AWS Fargate to run Terraform Cloud Agent containers. The agents will periodically poll Terraform Cloud or your Terraform Enterprise server for workloads.
<p>&nbsp;</p>

## Disclaimer
This Terraform module is intended to be used by Hashicorp Implementation Services (IS) in tandem with customers during Professional Services engagements in order to codify and automate the deployment of Terraform Agents via Terraform within the customers' cloud environments. After the Professional Services engagement finishes, the customer owns the code and is responsible for maintaining and supporting it.
<p>&nbsp;</p>

## Prerequisites
- Terraform `>= 1.1.3` installed on clients/workstations
- Agent Pool configured in either Terraform Cloud (TFC) or Terraform Enterprise (TFE)
- Agent Token
- AWS VPC and Subnet(s)
- Networking requirements in place depending on architecture (See Networking Requirements)  
<p>&nbsp;</p>

## Usage
```hcl
module "agents" {
  source = "../.."

  friendly_name_prefix = var.friendly_name_prefix
  common_tags          = var.common_tags
  region               = var.region

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  tfc_agent_token  = var.tfc_agent_token
  tfc_address      = var.tfc_address
  tfc_agent_name   = var.tfc_agent_name
  number_of_agents = var.number_of_agents
  agent_image      = var.agent_image
  assign_public_ip = var.assign_public_ip
  enable_logs      = var.enable_logs
  cpu              = var.cpu
  memory           = var.memory
}
```
<p>&nbsp;</p>

## Networking Requirements
| Hostname  | Port/Protocol | Directionality | Purpose |
| ------------- | ------------- | ----------| ---------|
| app.terraform.io (TFC Only)  | tcp/443, HTTPS  | Outbound | Polling for new workloads, providing status updates, and downloading private modules from Terraform Cloud's Private Module Registry | 
| my.tfe-example.com (TFE Only)  | tcp/443, HTTPS  | Outbound | Polling for new workloads, providing status updates, and downloading private modules from your Private Terraform Enterprise Server | 
| releases.hashicorp.com  | tcp/443, HTTPS  | Outbound | Updating agent components and downloading Terraform binaries | 
| registry.terraform.io  | tcp/443, HTTPS  | Outbound | Downloading public modules from the Terraform Registry |
| archivist.terraform.io | tcp/443, HTTPS  | Outbound | Blob Storage |
<p>&nbsp;</p>

![Diagram](docs/images/agents-networking.png)
<p>&nbsp;</p>

### Public Subnets Requirements:
- `assign_public_ip` set to `true`
- An IGW configured and routes configured to allow outbound access for HTTPS traffic to the required TFC/TFE hostnames.
<p>&nbsp;</p>

### Private Subnets Requirements:
- `assign_public_ip` set to `false`
- a NAT GW configured in a public subnet with routes configured to allow outbound access for HTTPS traffic to the required TFC/TFE hostnames.
<p>&nbsp;</p>

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.16.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.tfe_agents_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.agents](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.agents](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.agents](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs-task-execution-role-policy-attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.agents](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_image"></a> [agent\_image](#input\_agent\_image) | The registry/image:tag\_Version to use for the agent. Default = hashicorp/tfc-agent:latest | `string` | `"hashicorp/tfc-agent:latest"` | no |
| <a name="input_agent_log_level"></a> [agent\_log\_level](#input\_agent\_log\_level) | The log verbosity. Level options include 'trace', 'debug', 'info', 'warn', and 'error'. Log levels have a progressive level of data sensitivy. The 'info', 'warn', and 'error' levels are considered generally safe for log collection and don't include sensitive information. The 'debug' log level may include internal system details, such as specific commands and arguments including paths to user data on the local filesystem. The 'trace' log level is the most sensitive and may include personally identifiable information, secrets, pre-authorized internal URLs, and other sensitive material. | `string` | `"info"` | no |
| <a name="input_assign_public_ip"></a> [assign\_public\_ip](#input\_assign\_public\_ip) | Only required when using Fargate for ECS services placed in public subnets. Needed for fargate to assign ENI and pull docker image. True or False | `bool` | `"false"` | no |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | Map of common tags for taggable AWS resources. | `map(string)` | `{}` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | Number of cpu units used by the task. If the requires\_compatibilities is FARGATE this field is required. | `number` | `1024` | no |
| <a name="input_enable_logs"></a> [enable\_logs](#input\_enable\_logs) | Whether or not to enable tfc-agent ECS logs. | `bool` | `true` | no |
| <a name="input_friendly_name_prefix"></a> [friendly\_name\_prefix](#input\_friendly\_name\_prefix) | Friendly name to prefix AWS resource names with. | `string` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | Amount (in MiB) of memory used by the task. If the requires\_compatibilities is FARGATE this field is required. | `number` | `2048` | no |
| <a name="input_number_of_agents"></a> [number\_of\_agents](#input\_number\_of\_agents) | Number of cloud agents to run per instance. | `number` | `1` | no |
| <a name="input_region"></a> [region](#input\_region) | The AWS Region to deploy resources into. | `string` | `"us-east-1"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of Subnet IDs to use for ECS tasks or services. Format should be a list of strings. Example ['subnet1', 'subnet2'] | `list(string)` | n/a | yes |
| <a name="input_tfc_address"></a> [tfc\_address](#input\_tfc\_address) | Hostname of self-hosted TFE instance. Leave default if TFC is in use. | `string` | `"app.terraform.io"` | no |
| <a name="input_tfc_agent_name"></a> [tfc\_agent\_name](#input\_tfc\_agent\_name) | The name of the agent. | `string` | `"ecs-agent"` | no |
| <a name="input_tfc_agent_token"></a> [tfc\_agent\_token](#input\_tfc\_agent\_token) | Agent pool token to authenticate to TFC/TFE when cloud agents are instantiated. | `string` | n/a | yes |
| <a name="input_tfc_agent_version"></a> [tfc\_agent\_version](#input\_tfc\_agent\_version) | Version of tfc-agent to run. | `string` | `"1.2.0"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID for Security Group and ECS Service. | `string` | n/a | yes |
