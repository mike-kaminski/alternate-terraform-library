resource "aws_ecs_service" "service" {
  name                               = "${var.project}-${var.environment}"
  cluster                            = data.aws_ecs_cluster.cluster.id
  desired_count                      = var.replicas
  wait_for_steady_state              = true
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  enable_ecs_managed_tags            = "false"
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  launch_type                        = "FARGATE"
  platform_version                   = var.platform_version
  scheduling_strategy                = "REPLICA"
  task_definition                    = aws_ecs_task_definition.app.arn
  enable_execute_command             = true

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    container_name   = "${var.project}-${var.environment}"
    container_port   = var.port
    target_group_arn = aws_lb_target_group.app.arn
  }

  network_configuration {
    assign_public_ip = "false"
    security_groups  = [aws_security_group.allow-internal.id]
    subnets          = data.aws_subnet_ids.private.ids
  }

  depends_on = [
    aws_ecs_task_definition.app
  ]
}

resource "aws_ecs_task_definition" "app" {
  execution_role_arn       = aws_iam_role.execution.arn
  family                   = "${var.project}-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.task.arn
  cpu                      = var.cpu
  memory                   = var.memory
  container_definitions = jsonencode([
      {
        name  = "${var.project}-${var.environment}"
        image = "${var.source_ecr_repo}:${var.container_version}"
        portMappings = [
          {
            containerPort = var.port
            protocol      = "tcp"
          }
        ]
        essential = true
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-create-group  = "true"
            awslogs-group         = "/ecs/${var.project}"
            awslogs-region        = var.region
            awslogs-stream-prefix = var.environment
          }
        }
        environment : local.app_envvars
      }
    ]
  )
}

locals {
  app_envvars = flatten([
    for k, v in var.app_envvars : [
      {
        name  = k
        value = v
      }
    ]
  ])
}

resource "aws_appautoscaling_target" "service-target" {
  max_capacity       = var.autoscale_max_capacity
  min_capacity       = var.autoscale_min_capacity
  resource_id        = "service/${data.aws_ecs_cluster.cluster.cluster_name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "service-memory" {
  name               = "${var.project}-${var.environment}-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.service-target.resource_id
  scalable_dimension = aws_appautoscaling_target.service-target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.service-target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = var.memory_target_threshold
  }
}

resource "aws_appautoscaling_policy" "service-cpu" {
  name               = "${var.project}-${var.environment}-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.service-target.resource_id
  scalable_dimension = aws_appautoscaling_target.service-target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.service-target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = var.cpu_target_threshold
  }
}
