## Requirements

| Name | Version |
|------|---------|
| alks | ~> 1.5.12 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| alks | ~> 1.5.12 |
| aws | ~> 3.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [alks_iamrole](https://registry.terraform.io/providers/Cox-Automotive/alks/1.5.12/docs/resources/iamrole) |
| [aws_appautoscaling_policy](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/resources/appautoscaling_policy) |
| [aws_appautoscaling_target](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/resources/appautoscaling_target) |
| [aws_availability_zones](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/data-sources/availability_zones) |
| [aws_caller_identity](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/data-sources/caller_identity) |
| [aws_ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/data-sources/ecs_cluster) |
| [aws_ecs_service](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/resources/ecs_service) |
| [aws_ecs_task_definition](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/resources/ecs_task_definition) |
| [aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/resources/iam_policy) |
| [aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/resources/iam_role_policy_attachment) |
| [aws_lb_listener_rule](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/resources/lb_listener_rule) |
| [aws_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/data-sources/lb_listener) |
| [aws_lb_target_group](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/resources/lb_target_group) |
| [aws_lb](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/data-sources/lb) |
| [aws_route53_record](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/resources/route53_record) |
| [aws_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/data-sources/route53_zone) |
| [aws_secretsmanager_secret](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/data-sources/secretsmanager_secret) |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/resources/security_group) |
| [aws_service_discovery_service](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/resources/service_discovery_service) |
| [aws_subnet_ids](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/data-sources/subnet_ids) |
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/3.0/docs/data-sources/vpc) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_definitions | Map of environment variables for the application | `string` | `""` | no |
| autoscale\_max\_capacity | The max capacity for autoscaling | `string` | `"5"` | no |
| autoscale\_min\_capacity | The min capacity for autoscaling | `string` | `"1"` | no |
| container\_version | Container image version | `any` | n/a | yes |
| cpu | Number of cpu units used by the task | `number` | `512` | no |
| cpu\_target\_threshold | CPU target percentage to trigger autoscale | `string` | `"80"` | no |
| deployment\_maximum\_percent | Max percentage of the service's desired count during deployment | `string` | `"200"` | no |
| deployment\_minimum\_healthy\_percent | Min percentage of the service's desired count during deployment | `string` | `"100"` | no |
| dns\_zone | DNS Zone to create record | `string` | `"embarkvet.com"` | no |
| ecs\_cluster | ECS Cluster name to deploy the service | `any` | `null` | no |
| environment | Environment for deployment | `string` | `""` | no |
| health\_check\_grace\_period\_seconds | Seconds to ignore failing load balancer health checks on new tasks | `string` | `"120"` | no |
| health\_check\_path | Service health endpoint to check | `string` | `""` | no |
| lb\_name | ALB name to configure the listerner | `string` | `""` | no |
| memory | Amount (in MiB) of memory used by the task | `number` | `1024` | no |
| memory\_target\_threshold | Memory target percentage to trigger autoscale | `string` | `"80"` | no |
| path | Path to configure the alb listener | `string` | `"/*"` | no |
| platform\_version | Platform version on which to run your service. | `string` | `"1.4.0"` | no |
| port | Port the application runs on | `number` | `8080` | no |
| project | Project, aka the application name | `string` | `""` | no |
| public\_domain | Public full domain to access the application | `string` | `""` | no |
| region | AWS region for resources | `string` | `""` | no |
| replicas | Number of containers (instances) to run | `string` | `"1"` | no |
| task\_iam\_policy | Policy document for ecs task | `string` | `""` | no |
| vpc\_id | VPC ID to use for the resources | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| autoscaling\_dimension | The scalable dimension of the scalable target. |
| autoscaling\_namespace | The AWS service namespace of the scalable target. |
| autoscaling\_resource\_id | Unique identifier string for the resource associated with the scaling policy. |
| ecs\_service\_id | ARN of the ECS service. |
| ecs\_service\_name | Name of the ECS service. |
